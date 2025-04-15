/*
 * coreHTTP v2.0.2
 * Copyright (C) 2020 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
 * Copyright 2023 NXP
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#pragma once

/**
 * @file core_http_config_defaults.h
 * @brief The default values for the configuration macros for the HTTP Client
 * library.
 *
 * @note This file SHOULD NOT be modified. If custom values are needed for
 * any configuration macro, a core_http_config.h file should be provided to
 * the HTTP Client library to override the default values defined in this file.
 * To use the custom config file, the HTTP_DO_NOT_USE_CUSTOM_CONFIG preprocessor
 * macro SHOULD NOT be set.
 */

#include "transport_interface.h"
#include "fsl_debug_console.h"
#include "mbedtls/ssl.h"

/* *INDENT-OFF* */
#ifdef __cplusplus
extern "C" {
#endif
/* *INDENT-ON* */

// #define COREHTTP_DEBUG_PRINTS

/* CoreHTTP needs this struct to be user defined according
 * to used transport layer.
 */

struct NetworkContext
{
    mbedtls_ssl_context *sslCtx;
};

/* These recv/send functions are used to connect CoreHTTP
 * with a transport layer. Defined in core_http_config.c
 */

int32_t coreHttp_recv(NetworkContext_t *pNetworkContext, void *pBuffer, size_t bytesToRecv);

int32_t coreHttp_send(NetworkContext_t *pNetworkContext, const void *pBuffer, size_t bytesToSend);

/**
 * @brief Maximum size, in bytes, of headers allowed from the server.
 *
 * If the total size in bytes of the headers received from the server exceeds
 * this configuration, then the status code
 * #HTTPSecurityAlertResponseHeadersSizeLimitExceeded is returned from
 * #HTTPClient_Send.
 *
 * <b>Possible values:</b> Any positive 32 bit integer. <br>
 * <b>Default value:</b> `2048`
 */
#define HTTP_MAX_RESPONSE_HEADERS_SIZE_BYTES 2048U

/**
 * @brief The HTTP header "User-Agent" value.
 *
 * The following header line is automatically written to
 * #HTTPRequestHeaders_t.pBuffer:
 * "User-Agent: my-platform-name\r\n"
 *
 * <b>Possible values:</b> Any string. <br>
 * <b>Default value:</b> `my-platform-name`
 */
#define HTTP_USER_AGENT_VALUE "OTA_HTTP_DEMO"

/**
 * @brief The maximum duration between non-empty network reads while receiving
 * an HTTP response via the #HTTPClient_Send API function.
 *
 * The transport receive function may be called multiple times until the end of
 * the response is detected by the parser. This timeout represents the maximum
 * duration that is allowed without any data reception from the network for the
 * incoming response.
 *
 * If the timeout expires, the #HTTPClient_Send function will return
 * #HTTPNetworkError.
 *
 * If #HTTPResponse_t.getTime is set to NULL, then this HTTP_RECV_RETRY_TIMEOUT_MS
 * is unused. When this timeout is unused, #HTTPClient_Send will not retry the
 * transport receive calls that return zero bytes read.
 *
 * <b>Possible values:</b> Any positive 32 bit integer. A small timeout value
 * is recommended. <br>
 * <b>Default value:</b> `10`
 */
#define HTTP_RECV_RETRY_TIMEOUT_MS (10U)

/**
 * @brief The maximum duration between non-empty network transmissions while
 * sending an HTTP request via the #HTTPClient_Send API function.
 *
 * When sending an HTTP request, the transport send function may be called multiple
 * times until all of the required number of bytes are sent.
 * This timeout represents the maximum duration that is allowed for no data
 * transmission over the network through the transport send function.
 *
 * If the timeout expires, the #HTTPClient_Send function returns #HTTPNetworkError.
 *
 * If #HTTPResponse_t.getTime is set to NULL, then this HTTP_RECV_RETRY_TIMEOUT_MS
 * is unused. When this timeout is unused, #HTTPClient_Send will not retry the
 * transport send calls that return zero bytes sent.
 *
 * <b>Possible values:</b> Any positive 32 bit integer. A small timeout value
 * is recommended. <br>
 * <b>Default value:</b> `10`
 */
#define HTTP_SEND_RETRY_TIMEOUT_MS (10U)

/**
 * @brief Macro that is called in the HTTP Client library for logging "Error" level
 * messages.
 *
 * To enable error level logging in the HTTP Client library, this macro should be mapped to the
 * application-specific logging implementation that supports error logging.
 *
 * @note This logging macro is called in the HTTP Client library with parameters wrapped in
 * double parentheses to be ISO C89/C90 standard compliant. For a reference
 * POSIX implementation of the logging macros, refer to core_http_config.h files, and the
 * logging-stack in demos folder of the
 * [AWS IoT Embedded C SDK repository](https://github.com/aws/aws-iot-device-sdk-embedded-C).
 *
 * <b>Default value</b>: Error logging is turned off, and no code is generated for calls
 * to the macro in the HTTP Client library on compilation.
 */

#ifdef COREHTTP_DEBUG_PRINTS
#define LogDef(m)      \
    do                 \
    {                  \
        PRINTF m;      \
        PUTCHAR('\n'); \
    } while (0)
#else
#define LogDef(m)
#endif

#define LogError(message) LogDef(message)

/**
 * @brief Macro that is called in the HTTP Client library for logging "Warning" level
 * messages.
 *
 * To enable warning level logging in the HTTP Client library, this macro should be mapped to the
 * application-specific logging implementation that supports warning logging.
 *
 * @note This logging macro is called in the HTTP Client library with parameters wrapped in
 * double parentheses to be ISO C89/C90 standard compliant. For a reference
 * POSIX implementation of the logging macros, refer to core_http_config.h files, and the
 * logging-stack in demos folder of the
 * [AWS IoT Embedded C SDK repository](https://github.com/aws/aws-iot-device-sdk-embedded-C).
 *
 * <b>Default value</b>: Warning logs are turned off, and no code is generated for calls
 * to the macro in the HTTP Client library on compilation.
 */
#define LogWarn(message) LogDef(message)

/**
 * @brief Macro that is called in the HTTP Client library for logging "Info" level
 * messages.
 *
 * To enable info level logging in the HTTP Client library, this macro should be mapped to the
 * application-specific logging implementation that supports info logging.
 *
 * @note This logging macro is called in the HTTP Client library with parameters wrapped in
 * double parentheses to be ISO C89/C90 standard compliant. For a reference
 * POSIX implementation of the logging macros, refer to core_http_config.h files, and the
 * logging-stack in demos folder of the
 * [AWS IoT Embedded C SDK repository](https://github.com/aws/aws-iot-device-sdk-embedded-C).
 *
 * <b>Default value</b>: Info logging is turned off, and no code is generated for calls
 * to the macro in the HTTP Client library on compilation.
 */
#define LogInfo(message) LogDef(message)

/**
 * @brief Macro that is called in the HTTP Client library for logging "Debug" level
 * messages.
 *
 * To enable debug level logging from HTTP Client library, this macro should be mapped to the
 * application-specific logging implementation that supports debug logging.
 *
 * @note This logging macro is called in the HTTP Client library with parameters wrapped in
 * double parentheses to be ISO C89/C90 standard compliant. For a reference
 * POSIX implementation of the logging macros, refer to core_http_config.h files, and the
 * logging-stack in demos folder of the
 * [AWS IoT Embedded C SDK repository](https://github.com/aws/aws-iot-device-sdk-embedded-C).
 *
 * <b>Default value</b>: Debug logging is turned off, and no code is generated for calls
 * to the macro in the HTTP Client library on compilation.
 */
#define LogDebug(message) LogDef(message)

/* *INDENT-OFF* */
#ifdef __cplusplus
}
#endif
/* *INDENT-ON* */
