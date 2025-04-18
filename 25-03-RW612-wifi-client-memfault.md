# Steps to add Remote Diagnostics to WiFi product
Modern products all come with connectivity options.  We are able to connect our mobile phone with a device to configure or get notifications.  
However, an important advancement in connected devices is the ability to ***"phone home".*** Device's are able to provide telemetry data with the producer of the product. This was made popular with mobile phones. You receieve updates, but you also provide information back to the provider. This allows them to continualy improve their software updates and product features.
NXP has partnered with Memfault to provide the mechanisms for adding this type of service to a connected product.  THe following exercise details how a user can add Memfault services to a connected NXP microcontroller.  The MCUXpresso and Memfault SDK partner to get you started quickly.

## Process to convert a Wifi connected RW612 project
1. Import and Build working WiFi project
2. Add Memfault components to project using cmake. Verify project still works
3. Add Memfault example code to project and leverage shell menu. Test added memfault routines.
4. Update project to connect with Memfault web dashboard. Verify connectivity to Memfault
5. Update Memfault dashboard to properly receive and decipher telemetry sent from RW612 WiFi project
6. Use device menu and Memfault dashboard to evaluate the capture and exchange of device information

## 1.0 Import and Build Working WiFI Project
1. Install MCUXpresso SDK 25.03.00 or newer
2. Import Example for FRDM-RW612. "ota_mcuboot_client_wifi"

### 1.1 Move application to boot space.  Remove mcuboot
The selected project includes an Https client and most of the code commonly found in a connected device.  However, the default project includes a bootloader which adds complexity to the process.  We can remove the bootloader requirement by moving the start of main to the boot location.  The following steps show how to remove the 0x200000 reserved for the bootloader from the linker file.  
    - Change STACK_SIZE from 0x400 to 0x800. Data dumping is handled in exception handler, so the main stack should be large enough.  
    - Shrink the length of m_text by 0x8000, this region is reserved to save dumped data.  
    - Need to place objects in RAM, **like fsl_flexspi.c**, because these functions might be called when the flash is being programed or erased, so place them in RAM.  
1. Open RW610_flash.ld found in /armgcc of project
2. Replace initial lines of linker file that specify the offset memory locations.
    ``` c++
    MEMORY
    {
        m_flash_config        (RX)  : ORIGIN = 0x08000000, LENGTH = 0x00001000
        m_interrupts          (RX)  : ORIGIN = 0x08001000, LENGTH = 0x00000280
        m_text                (RX)  : ORIGIN = 0x08001280, LENGTH = 0x001FED80 - 0x8000 /* 32K(0x8000) in the end reserved for memfault */
        m_data                (RW)  : ORIGIN = 0x20000000, LENGTH = 0x00130000
        m_mbox1               (RW) : ORIGIN = 0x41380000, LENGTH = 0x00000488
        m_txq1                (RW) : ORIGIN = 0x41380488, LENGTH = 0x00001000
        m_mbox2               (RW) : ORIGIN = 0x443C0000, LENGTH = 0x00000488
        m_txq2                (RW) : ORIGIN = 0x443C0488, LENGTH = 0x00001080
    }
    ```
3. Add .flash_config definition to the start of output sections, in order of memory sections
    ``` c++
    .flash_config :
    {
        . = ALIGN(4);
        FILL(0xFF)
        . = 0x400;
        __FLASH_BASE = .;
        KEEP(* (.flash_conf))     /* flash config section */
        . = 0x1000;
    } > m_flash_config
    ```
4. Verify that new sections are added to the lists for sections
    In the Uninitialized data section, memfault needs to be added. Immediately following __bss_start__ = ,;  
    ``` c++
    __memfault_capture_bss_start = .;
    */tasks.c.obj(.bss COMMON .bss*)
    */timers.c.obj(.bss COMMON .bss*)
    __memfault_capture_bss_end = .;
    ```

### 1.2 Update WiFi Access Point
3. Replace WiFi Access Point (AP) name and password with an available AP in the **network_cfg.h** file.  
    __NOTE:__ A mobile phone Hotspot is an easy to configure AP option.

    ``` c++
    /* Common WiFi parameters */
    #ifndef WIFI_SSID
    #define WIFI_SSID "Kyle's iPhone"
    #endif

    #ifndef WIFI_PASSWORD
    #define WIFI_PASSWORD "12345678"
    #endif
    ```
4. Build and Debug to verify base product connects to the AP successfully.  
    Type "wifi join" in the shell command.  
    The added common wifi parameters will be used to attempt a connection.  
    Expected result will print "Successfully joined: "XYZ AP". Got IP address" 

## 2.0 Add Memfault components to project using cmake
The MCUXpresso project is configured using cmake settings.  The MCUXpresso VS Code extension includes a manager that can add available components to a selected project. The chosen components are added to the end of the **config.cmake** project file.
1. Click on the RW612 wifi project found in the list of Projects in the MCUXPresso extension view  
    ![ComponentManager](VSCode-COmponent-Manager.png)
2. The extension loads the available software components, and displays them from the top drop down taskbar.  Type **Memfault** to filter the displayed components.
3. Add the memfault components by selecting and clicking OK:
    - memfault_sdk
    - memfault_sdk_metrics
    - memfault_sdk_ports_freertos
    - memfault_sdk_ports_mcuxsdk
4. Remove conflicting "assert" component.  
    It can be set to (false), commented out or deleted from **config.cmake**
5. Remove 3 eroneously added freertos components.  They will be found at end of **config.cmake** 
    Confirm Memfault components are included in file before saving/closing.
6. Rebuild the project to confirm that added components did not introduce any conflicts/dependencies.
    This would be the result if the freertos or the assert components were not removed.  

## 3.0 Add Memfault example code to project and leverage shell menu
### 3.1 Replace Host/Port with Memfault SDK Defines (ota_mcuboot_client.c)
   This will change the server name in the main project file.  Versus modifying HTTPS_SERVER_ values in httpsclient.c.  
   The values are defined in the Memfault SDK, should be discovered with Cmake modification in step 2.0.

    ``` c++
    char *host = MEMFAULT_HTTP_CHUNKS_API_HOST;
    char *port = MEMFAULT_HTTP_APIS_DEFAULT_PORT;
    ```
### 3.1.Temp Server DNS work around (ota_config.h)  
   **__NOTE:__** We found that DNS was not working.  SO we replaced name with IP address.  We will look into how to resolve this limitation.  This step can be removed once DNS is resolved.  
    ``` c++
    const char *HTTPS_SERVER_NAME = "54.235.98.107";
    const char *HTTPS_SERVER_PORT = "443";
    ```

## 3.2 Modify TLS settings to allow Connection to Memfault Server
Need to connect with chunks.memfault.com or in code MEMFAULT_HTTP_CHUNKS_API_HOST
Requires client Certificate Authority (CA) cert to be replaced with expected valid Memfault cert. 
1. Update mbedtls configuration with Memfault requirements
    Add following definitions to **mbedtlc_user-config.h**
    ``` c++
    #define MBEDTLS_SSL_SERVER_NAME_INDICATION 1
    #define MBEDTLS_BASE64_C 1
    #define MBEDTLS_PEM_PARSE_C 1
    ```

2. Replace existing test CA cert with Memfault certificate
    ``` c++
    const char memfault_cert[] = MEMFAULT_ROOT_CERTS_DIGICERT_GLOBAL_ROOT_G2;
    size_t memfault_cert_len = sizeof(memfault_cert);

    DEBUG_PRINTF("  . Loading the CA root certificate ...");
    ret = mbedtls_x509_crt_parse(&(tlsDataParams.cacert), (const unsigned char *)memfault_cert, memfault_cert_len);
    ```
## 3.3 Add Includes/Defines to OTA Wifi Client Project
1. Add #include for memfault components and ports for freertos
    ``` c++
    #include "memfault/components.h"
    #include "memfault/ports/freertos.h"
    ```
    This may require the following includes to be added for FreeRTOS if not in project being ported:
    ```
    /* FreeRTOS kernel includes. */
    #include "FreeRTOS.h"
    #include "task.h"
    #include "queue.h"
    #include "timers.h"
    ```
2. Add memfault_platform_boot(); to main() in **ota_mcuboot_client.c**
    Function can be called after existing BoardInit() routines.
    **_NOTE_** Ctrl - Right Click on function and it opens from Memfault SDK)  
3. Copy Memfault configuration values into **mcux_config.h** 
    ``` c++
    #define CONFIG_MEMFAULT_DEVICE_SERIAL "NXP_RW612"
    #define CONFIG_MEMFAULT_SW_VERSION "1.0.0"
    #define CONFIG_MEMFAULT_HW_VERSION "FRDM-RW612"
    #define CONFIG_MEMFAULT_FLASH_BASE_OFFSET 0x001F8000
    #define CONFIG_MEMFAULT_FLASH_SIZE 0x00008000
    #define CONFIG_MEMFAULT_SW_TYPE "wifi-mqtt-memfault"
    ```

4. Modify **FreeRTOSConfig_frag.h** to support Memfault  
    ``` c++
    #include "memfault/ports/freertos_trace.h"
    ```
5. Modify **FreeRTOSConfig.h** to support Memfault
    Modify the current settings with following
    ``` c++
    #define INCLUDE_uxTaskGetStackHighWaterMark 1
    #define INCLUDE_xTaskGetIdleTaskHandle      0
    #define INCLUDE_eTaskGetState               0
    #define INCLUDE_xTimerPendFunctionCall      1
    #define INCLUDE_xTaskAbortDelay             0
    #define INCLUDE_xTaskGetHandle              0

    ```  
    
    Add the following missing defines to the end of FreeRTOS Config
    ``` c++
    #define vPortSVCHandler SVC_Handler
    #define xPortPendSVHandler PendSV_Handler
    #define xPortSysTickHandler SysTick_Handler
    ```
    **_TIP:_** Use Build errors by opening explorer or "Repository" view.  Push down into project to find "RED" file.  Likely this will uncover an include that is not updated properly.

## 3.4 Add Memfault routines and add new shell commands
2. Copy/Paste sections from working Memfault example into reserved sections of wifi example (i.e. Variables and Prototypes)
    
    Copy/Paste self_test(), dump_data(), and trigger_fault() from working example to end of wifi_mqtt.c
1. Declare each function for Memfault shell commands
    ```
    static shell_status_t shellCmd_trigger(shell_handle_t shellHandle, int32_t argc, char **argv);
    static shell_status_t shellCmd_dump(shell_handle_t shellHandle, int32_t argc, char **argv);
    static shell_status_t shellCmd_test(shell_handle_t shellHandle, int32_t argc, char **argv);
    ```

1. Define each Shell Command
    ```
    static SHELL_COMMAND_DEFINE(test, "\n\"Self Test\": Runs Memfault self-test\n", shellCmd_test, 0);
    ```

2. Create Shell routine calling Memfault routine.
    ```
        static shell_status_t shellCmd_test(shell_handle_t shellHandle, int32_t argc, char **argv)
    {
        PRINTF("Memfault Self Test!\n");
        self_test();

        /* return kStatus_SHELL_Success; */
    }
    ```
3.  Register the shell commandS in the OTA task for it to be valid
    ```
        SHELL_RegisterCommand(s_shellHandle, SHELL_COMMAND(trigger));
    ```

## 3.5 Modify Default Httpsclient.c for Memfault 
1. Add the Project Key from Memfault dashboard into httpsclient.c
    Found under the desired dashboard in app.memfault.com
    Example: NXP Marketing is "CxsNSPBMoJdnuSaTOT2LIZPy8pKoJgtI"
    ```
        // Memfault project key
    const char *memfault_project_key = "<YOUR PROJECT KEY HERE>";
    ```
2.  Add include stdio.h for string passing
3.  Add Debug and TLS Definitions
    ```
    /* This is the value used for ssl read timeout */
    #define IOT_SSL_READ_TIMEOUT 10
    #define GET_REQUEST                                           \
    "GET /media/uploads/mbed_official/hello.txt HTTP/1.0\r\n" \
    "HOST: os.mbed.com\r\n\r\n"
    ```
4.  Add write_request() and read_request()
    Paste after the lwip_send and lwip_read.  Before MY_DEBUG
    ```
        int write_request(void *chunk_data, size_t chunk_data_len)
    {
        /*
        * Write the POST request
        */
        int ret = 0;

        // format string for building the HTTP header
    #define POST_REQUEST                                                           \
    "POST /api/v0/chunks/%s HTTP/1.1\r\n"                                \
    "Host:chunks.memfault.com\r\n"                                               \
    "User-Agent: MemfaultSDK/0.4.2\r\n"                                          \
    "Memfault-Project-Key:%s\r\n"                                                \
    "Content-Type:application/octet-stream\r\n"                                  \
    "Content-Length:%d\r\n\r\n"


        // format the request
        unsigned char sendbuf[1048];
        sMemfaultDeviceInfo device_info;
        memfault_platform_get_device_info(&device_info);
        size_t len =
            sprintf((char *)sendbuf, POST_REQUEST, device_info.device_serial,
                    memfault_project_key, chunk_data_len);

        DEBUG_PRINTF( "  > Write to server:" );

        DEBUG_PRINTF("\nHeader: \n%s", sendbuf);

        // send the header
        while( ( ret = mbedtls_ssl_write( &(tlsDataParams.ssl), sendbuf, len ) ) <= 0 )
        {
            if( ret != MBEDTLS_ERR_SSL_WANT_READ && ret != MBEDTLS_ERR_SSL_WANT_WRITE )
            {
                PRINTF( "\n failed\n  ! mbedtls_ssl_write returned %d\n\n", ret );
                goto exit;
            }
        }

        len = ret;
        DEBUG_PRINTF( "\n %d header bytes written\n\n", len);

        // send the payload
        while ((ret = mbedtls_ssl_write(&(tlsDataParams.ssl),
                                        (const unsigned char *)chunk_data,
                                        chunk_data_len)) <= 0) {
        if (ret != MBEDTLS_ERR_SSL_WANT_READ &&
            ret != MBEDTLS_ERR_SSL_WANT_WRITE) {
            PRINTF(" failed\n  ! mbedtls_ssl_write returned %d\n\n", ret);
            goto exit;
        }
        }

        len = ret;
        DEBUG_PRINTF(" %d bytes written\n\n%s", len, (char *)https_buf);

        return ret;

    exit:
        https_client_tls_release();
        return -1;
    }

    int read_request(void)
    {
        /*
        * Read the HTTPS response
        */
        int ret = 0;
        int len = 0;
        DEBUG_PRINTF("  < Read from server:");

        do
        {
            len = sizeof(https_buf) - 1;
            memset(https_buf, 0, sizeof(https_buf));
            ret = mbedtls_ssl_read(&(tlsDataParams.ssl), https_buf, len);

            if (ret == MBEDTLS_ERR_SSL_WANT_READ || ret == MBEDTLS_ERR_SSL_WANT_WRITE)
                continue;

            if (ret == MBEDTLS_ERR_SSL_PEER_CLOSE_NOTIFY)
                break;

            if (ret < 0)
            {
                PRINTF("failed\n  ! mbedtls_ssl_read returned %d\n\n", ret);
                goto exit;
            }

            if (ret == 0)
            {
                DEBUG_PRINTF("\n\nEOF\n\n");
                break;
            }

            len = ret;
            DEBUG_PRINTF(" %d bytes read\n\n%s", len, (char *)https_buf);

            // the connection doesn't hang up until 30 seconds after the HTTP
            // request completes, so check for an HTTP response code
            if (strstr(https_buf, "HTTP/1.1 ")) {
                DEBUG_PRINTF("  . Response received, exiting\n");
                break;
            }
        } while (1);

        if (strstr(https_buf, "HTTP/1.1 202 Accepted")) {
            PRINTF("  < HTTP 202 Accepted received!\n");
            ret = 0;
        } else {
            PRINTF(" HTTP Response error:\n%s\n", https_buf);
            ret = -1;
        }

        return ret;

    exit:
        https_client_tls_release();
        return -1;
    }

    static int _iot_tls_verify_cert(void *data, mbedtls_x509_crt *crt, int depth, uint32_t *flags)
    {
        char buf[1024];
        ((void)data);

        DEBUG_PRINTF("\nVerify requested for (Depth %d):\n", depth);
        mbedtls_x509_crt_info(buf, sizeof(buf) - 1, "", crt);
        DEBUG_PRINTF("%s", buf);

        if ((*flags) == 0)
        {
            DEBUG_PRINTF("  This certificate has no flags\n");
        }
        else
        {
            DEBUG_PRINTF(buf, sizeof(buf), "  ! ", *flags);
            DEBUG_PRINTF("%s\n", buf);
        }

        return 0;
    }
    ```
## 3.6 Add Memfault Send CHunks at the end of HTTPSClient TLS Handshake
    ```
    #ifdef MBEDTLS_DEBUG_C
    if (mbedtls_ssl_get_peer_cert(&(tlsDataParams.ssl)) != NULL)
    {
        DEBUG_PRINTF("  . Peer certificate information    ...\n");
        mbedtls_x509_crt_info((char *)buf, sizeof(buf) - 1, "      ", mbedtls_ssl_get_peer_cert(&(tlsDataParams.ssl)));
        DEBUG_PRINTF("%s\n", buf);
    }
#endif

    mbedtls_ssl_conf_read_timeout(&(tlsDataParams.conf), IOT_SSL_READ_TIMEOUT);

      // buffer to copy chunk data into
      while (memfault_packetizer_data_available()) {
        uint8_t buf[512];
        size_t buf_len = sizeof(buf);

        bool data_available = memfault_packetizer_get_chunk(buf, &buf_len);
        if (!data_available ) {
            return false; // no more data to send
        }

        // // example chunk data
        // const unsigned char chunk[] = {
        //     0x08, 0x02, 0xa7, 0x02, 0x01, 0x03, 0x01, 0x07, 0x6a, 0x54, 0x45,
        //     0x53, 0x54, 0x53, 0x45, 0x52, 0x49, 0x41, 0x4c, 0x0a, 0x6d, 0x74,
        //     0x65, 0x73, 0x74, 0x2d, 0x73, 0x6f, 0x66, 0x74, 0x77, 0x61, 0x72,
        //     0x65, 0x09, 0x6a, 0x31, 0x2e, 0x30, 0x2e, 0x30, 0x2d, 0x74, 0x65,
        //     0x73, 0x74, 0x06, 0x6d, 0x74, 0x65, 0x73, 0x74, 0x2d, 0x68, 0x61,
        //     0x72, 0x64, 0x77, 0x61, 0x72, 0x65, 0x04, 0xa1, 0x01, 0xa1, 0x72,
        //     0x63, 0x68, 0x75, 0x6e, 0x6b, 0x5f, 0x74, 0x65, 0x73, 0x74, 0x5f,
        //     0x73, 0x75, 0x63, 0x63, 0x65, 0x73, 0x73, 0x01, 0x31, 0xe4};

        PRINTF("\nSending chunk of size %d\n", buf_len);
        ret = write_request(buf, buf_len);
        if (ret != buf_len) {
            PRINTF("Error! chunk write request failed\n");
            break;
        }

        ret = read_request();
                if (ret != 0) {
            PRINTF("Error! chunk write response failed\n");
            break;
        }
      }

    https_client_tls_release();
    ```

## 3.7 Use tls command to send data to Memfault
1.     https_client_tls_init();

## 4.0 Build and DEbug Memfault Coredump/REmote Diagnostics
### 4.1 Use Pyserial for COM Port
1. pyserial-miniterm in command line.  If fails.  Install py pyserial-miniterm
2. Determine what ports are available for connection.  pyserial-miniterm
3. Enter COM port for J-Link i.e. COM4
   pyserial-miniterm --raw COM4 115200

## 5.0 Verify Memfault account setup
1. Register for Memfault account at www.memfault.com
2. Import Example for FRDM-RW612. "memfault".
3. Build and Debug to verify base memfault enablement works.
4. Assert a coredump using CLI.  Dump chunks.  Copy to clipboard
5. Login to memfault dashboard
6. Open "Integration Hub" Chunks Debug from left navigation
7. Paste coredump from clipboard into "Manual Chunks Upload" window
8. Verify Preview decodes chunks as Fault condition
6. Create Software -> Version.  Put "MEMFAULT_SW_TYPE" for type.  Put "MEMFAULT_SW_VERSION" for Latest Version.
9. Upload Symbol File.  Select value in Identifiers from prior step: Type="MEMFAULT_SW_TYPE", Version="MEMFAULT_SW_VERSION"
10. Go to Devices and you should see Chunk import is now associated with Symbol File / Version.  Also "MEMFAULT_HW_VERSION" is pulled from chunks.
11. Go to All Dashboards, you will see new Issues.
12. Explore Issues.  You will see Hard Fault at trigger_fault as many times as you upload Chunks