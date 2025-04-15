IF(NOT DEFINED FPU)  
    SET(FPU "-mfloat-abi=hard -mfpu=fpv5-sp-d16")  
ENDIF()  

IF(NOT DEFINED SPECS)  
    SET(SPECS "--specs=nosys.specs")  
ENDIF()  

IF(NOT DEFINED DEBUG_CONSOLE_CONFIG)  
    SET(DEBUG_CONSOLE_CONFIG "-DSDK_DEBUGCONSOLE=1")  
ENDIF()  

SET(CMAKE_ASM_FLAGS_FLASH_DEBUG " \
    ${CMAKE_ASM_FLAGS_FLASH_DEBUG} \
    -D__STARTUP_CLEAR_BSS \
    -DMCUXPRESSO_SDK \
    -DCPU_RW612ETA2I \
    -DOSA_USED \
    -g \
    -mthumb \
    -mcpu=cortex-m33+nodsp \
    ${FPU} \
")
SET(CMAKE_ASM_FLAGS_FLASH_RELEASE " \
    ${CMAKE_ASM_FLAGS_FLASH_RELEASE} \
    -D__STARTUP_CLEAR_BSS \
    -DMCUXPRESSO_SDK \
    -DCPU_RW612ETA2I \
    -DOSA_USED \
    -mthumb \
    -mcpu=cortex-m33+nodsp \
    ${FPU} \
")
SET(CMAKE_C_FLAGS_FLASH_DEBUG " \
    ${CMAKE_C_FLAGS_FLASH_DEBUG} \
    -include ${ProjDirPath}/../wifi_config.h \
    -include ${ProjDirPath}/../mcux_config.h \
    -DDEBUG \
    -D_POSIX_SOURCE \
    -DPRINTF_ADVANCED_ENABLE=1 \
    -DMCUBOOT_APPLICATION=1 \
    -DUSE_RTOS=1 \
    -DLWIP_DNS=1 \
    -DLWIP_DHCP=1 \
    -DENET_RXBUFF_NUM=14 \
    -DSHELL_BUFFER_SIZE=128U \
    -DSHELL_TASK_PRIORITY=1 \
    -DCONFIG_MONOLITHIC_WIFI=1 \
    -DMCUX_META_BUILD \
    -DMCUXPRESSO_SDK \
    -DCPU_RW612ETA2I \
    -DOSA_USED \
    -DBOOT_HEADER_ENABLE=1 \
    -DSERIAL_PORT_TYPE_UART=1 \
    -DWIFI_BOARD_FRDM_RW61X \
    -DMFLASH_FILE_BASEADDR=7340032 \
    -DCONFIG_NXP_WIFI_SOFTAP_SUPPORT=1 \
    -DMBEDTLS_MCUX_ELS_API \
    -DMBEDTLS_MCUX_USE_ELS \
    -DMCUXCL_FEATURE_CSSL_MEMORY_C_FALLBACK \
    -DMBEDTLS_MCUX_ELS_PKC_API \
    -DMBEDTLS_MCUX_USE_PKC \
    -DPRINTF_FLOAT_ENABLE=1 \
    -DSO_REUSE=1 \
    -DSDK_OS_FREE_RTOS \
    -g \
    -O0 \
    --specs=nano.specs \
    -Wall \
    -fno-common \
    -ffunction-sections \
    -fdata-sections \
    -fno-builtin \
    -mthumb \
    -mapcs \
    -std=gnu99 \
    -mcpu=cortex-m33+nodsp \
    -fomit-frame-pointer \
    -Wno-unused-function \
    ${FPU} \
    ${DEBUG_CONSOLE_CONFIG} \
")
SET(CMAKE_C_FLAGS_FLASH_RELEASE " \
    ${CMAKE_C_FLAGS_FLASH_RELEASE} \
    -include ${ProjDirPath}/../wifi_config.h \
    -include ${ProjDirPath}/../mcux_config.h \
    -DNDEBUG \
    -D_POSIX_SOURCE \
    -DPRINTF_ADVANCED_ENABLE=1 \
    -DMCUBOOT_APPLICATION=1 \
    -DUSE_RTOS=1 \
    -DLWIP_DNS=1 \
    -DLWIP_DHCP=1 \
    -DENET_RXBUFF_NUM=14 \
    -DSHELL_BUFFER_SIZE=128U \
    -DSHELL_TASK_PRIORITY=1 \
    -DCONFIG_MONOLITHIC_WIFI=1 \
    -DMCUX_META_BUILD \
    -DMCUXPRESSO_SDK \
    -DCPU_RW612ETA2I \
    -DOSA_USED \
    -DBOOT_HEADER_ENABLE=1 \
    -DSERIAL_PORT_TYPE_UART=1 \
    -DWIFI_BOARD_FRDM_RW61X \
    -DMFLASH_FILE_BASEADDR=7340032 \
    -DCONFIG_NXP_WIFI_SOFTAP_SUPPORT=1 \
    -DMBEDTLS_MCUX_ELS_API \
    -DMBEDTLS_MCUX_USE_ELS \
    -DMCUXCL_FEATURE_CSSL_MEMORY_C_FALLBACK \
    -DMBEDTLS_MCUX_ELS_PKC_API \
    -DMBEDTLS_MCUX_USE_PKC \
    -DPRINTF_FLOAT_ENABLE=1 \
    -DSO_REUSE=1 \
    -DSDK_OS_FREE_RTOS \
    -Os \
    --specs=nano.specs \
    -Wall \
    -fno-common \
    -ffunction-sections \
    -fdata-sections \
    -fno-builtin \
    -mthumb \
    -mapcs \
    -std=gnu99 \
    -mcpu=cortex-m33+nodsp \
    -fomit-frame-pointer \
    -Wno-unused-function \
    ${FPU} \
    ${DEBUG_CONSOLE_CONFIG} \
")
SET(CMAKE_CXX_FLAGS_FLASH_DEBUG " \
    ${CMAKE_CXX_FLAGS_FLASH_DEBUG} \
    -DDEBUG \
    -DMCUX_META_BUILD \
    -DMCUXPRESSO_SDK \
    -DCPU_RW612ETA2I \
    -DOSA_USED \
    -DBOOT_HEADER_ENABLE=1 \
    -DSERIAL_PORT_TYPE_UART=1 \
    -DUSE_RTOS=1 \
    -DWIFI_BOARD_FRDM_RW61X \
    -DMFLASH_FILE_BASEADDR=7340032 \
    -DMBEDTLS_MCUX_ELS_API \
    -DMBEDTLS_MCUX_USE_ELS \
    -DMCUXCL_FEATURE_CSSL_MEMORY_C_FALLBACK \
    -DMBEDTLS_MCUX_ELS_PKC_API \
    -DMBEDTLS_MCUX_USE_PKC \
    -DPRINTF_FLOAT_ENABLE=1 \
    -DSO_REUSE=1 \
    -DSDK_OS_FREE_RTOS \
    -g \
    -O0 \
    --specs=nano.specs \
    -Wall \
    -fno-common \
    -ffunction-sections \
    -fdata-sections \
    -fno-builtin \
    -mthumb \
    -mapcs \
    -fno-rtti \
    -fno-exceptions \
    -mcpu=cortex-m33+nodsp \
    ${FPU} \
    ${DEBUG_CONSOLE_CONFIG} \
")
SET(CMAKE_CXX_FLAGS_FLASH_RELEASE " \
    ${CMAKE_CXX_FLAGS_FLASH_RELEASE} \
    -DNDEBUG \
    -DMCUX_META_BUILD \
    -DMCUXPRESSO_SDK \
    -DCPU_RW612ETA2I \
    -DOSA_USED \
    -DBOOT_HEADER_ENABLE=1 \
    -DSERIAL_PORT_TYPE_UART=1 \
    -DUSE_RTOS=1 \
    -DWIFI_BOARD_FRDM_RW61X \
    -DMFLASH_FILE_BASEADDR=7340032 \
    -DMBEDTLS_MCUX_ELS_API \
    -DMBEDTLS_MCUX_USE_ELS \
    -DMCUXCL_FEATURE_CSSL_MEMORY_C_FALLBACK \
    -DMBEDTLS_MCUX_ELS_PKC_API \
    -DMBEDTLS_MCUX_USE_PKC \
    -DPRINTF_FLOAT_ENABLE=1 \
    -DSO_REUSE=1 \
    -DSDK_OS_FREE_RTOS \
    -Os \
    --specs=nano.specs \
    -Wall \
    -fno-common \
    -ffunction-sections \
    -fdata-sections \
    -fno-builtin \
    -mthumb \
    -mapcs \
    -fno-rtti \
    -fno-exceptions \
    -mcpu=cortex-m33+nodsp \
    ${FPU} \
    ${DEBUG_CONSOLE_CONFIG} \
")
SET(CMAKE_EXE_LINKER_FLAGS_FLASH_DEBUG " \
    ${CMAKE_EXE_LINKER_FLAGS_FLASH_DEBUG} \
    -g \
    -Xlinker \
    --defsym=__stack_size__=0x2000 \
    -Xlinker \
    --defsym=__heap_size__=0x2000 \
    -Xlinker \
    -Map=output.map \
    -Wall \
    -fno-common \
    -ffunction-sections \
    -fdata-sections \
    -fno-builtin \
    -mthumb \
    -mapcs \
    -Wl,--gc-sections \
    -Wl,-static \
    -Wl,--print-memory-usage \
    -mcpu=cortex-m33+nodsp \
    ${FPU} \
    ${SPECS} \
    -T\"${ProjDirPath}/RW610_flash.ld\" -static \
")
SET(CMAKE_EXE_LINKER_FLAGS_FLASH_RELEASE " \
    ${CMAKE_EXE_LINKER_FLAGS_FLASH_RELEASE} \
    -Xlinker \
    --defsym=__stack_size__=0x2000 \
    -Xlinker \
    --defsym=__heap_size__=0x2000 \
    -Xlinker \
    -Map=output.map \
    -Wall \
    -fno-common \
    -ffunction-sections \
    -fdata-sections \
    -fno-builtin \
    -mthumb \
    -mapcs \
    -Wl,--gc-sections \
    -Wl,-static \
    -Wl,--print-memory-usage \
    -mcpu=cortex-m33+nodsp \
    ${FPU} \
    ${SPECS} \
    -T\"${ProjDirPath}/RW610_flash.ld\" -static \
")
