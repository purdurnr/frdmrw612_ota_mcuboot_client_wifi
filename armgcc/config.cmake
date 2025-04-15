# config to select component, the format is CONFIG_USE_${component}
# Please refer to cmake files below to get available components:
#  ${SdkRootDirPath}/devices/RW612/all_lib_device.cmake

set(CONFIG_COMPILER gcc)
set(CONFIG_TOOLCHAIN armgcc)
set(CONFIG_USE_COMPONENT_CONFIGURATION false)
set(CONFIG_USE_driver_flash_config true)
set(CONFIG_USE_driver_clock true)
set(CONFIG_USE_driver_i2s_bridge true)
set(CONFIG_USE_driver_inputmux_connections true)
set(CONFIG_USE_driver_io_mux true)
set(CONFIG_USE_driver_iped_rw61x true)
set(CONFIG_USE_driver_memory true)
set(CONFIG_USE_driver_ocotp_rw61x true)
set(CONFIG_USE_driver_power true)
set(CONFIG_USE_driver_reset true)
set(CONFIG_USE_CMSIS_Include_core_cm true)
set(CONFIG_USE_device_CMSIS true)
set(CONFIG_USE_device_system true)
set(CONFIG_USE_device_startup true)
set(CONFIG_USE_driver_cache_cache64 true)
set(CONFIG_USE_driver_common true)
set(CONFIG_USE_driver_flexcomm true)
set(CONFIG_USE_driver_flexcomm_usart true)
set(CONFIG_USE_driver_flexspi true)
set(CONFIG_USE_driver_gdma true)
set(CONFIG_USE_driver_imu true)
set(CONFIG_USE_driver_inputmux true)
set(CONFIG_USE_driver_lpc_gpio true)
set(CONFIG_USE_driver_pint true)
set(CONFIG_USE_driver_trng true)
set(CONFIG_USE_driver_flexcomm_usart_freertos true)
# set(CONFIG_USE_utility_assert true)
set(CONFIG_USE_utilities_misc_utilities true)
set(CONFIG_USE_component_lists true)
set(CONFIG_USE_utility_str true)
set(CONFIG_USE_utility_debug_console true)
set(CONFIG_USE_utility_shell true)
set(CONFIG_USE_component_serial_manager true)
set(CONFIG_USE_component_serial_manager_uart true)
set(CONFIG_USE_component_lpc_gpio_adapter true)
set(CONFIG_USE_component_usart_adapter true)
set(CONFIG_USE_component_wireless_imu_adapter true)
set(CONFIG_USE_component_osa_template_config true)
set(CONFIG_USE_component_osa true)
set(CONFIG_USE_component_osa_free_rtos true)
set(CONFIG_USE_middleware_edgefast_wifi_nxp true)
set(CONFIG_USE_component_wifi_bt_module_tx_pwr_limits true)
set(CONFIG_USE_component_wifi_bt_module_config true)
set(CONFIG_USE_component_wifi_bt_module_RW61X true)
set(CONFIG_USE_component_wifi_bt_module_board_frdm_rw61x true)
set(CONFIG_USE_component_els_pkc_doc_rw61x true)
set(CONFIG_USE_component_els_pkc_static_lib_rw61x true)
set(CONFIG_USE_component_els_pkc_aead true)
set(CONFIG_USE_component_els_pkc_aead_modes true)
set(CONFIG_USE_component_els_pkc_aes true)
set(CONFIG_USE_component_els_pkc_buffer true)
set(CONFIG_USE_component_els_pkc_cipher true)
set(CONFIG_USE_component_els_pkc_cipher_modes true)
set(CONFIG_USE_component_els_pkc_core true)
set(CONFIG_USE_component_els_pkc_ecc true)
set(CONFIG_USE_component_els_pkc_els_header_only true)
set(CONFIG_USE_component_els_pkc_els_common true)
set(CONFIG_USE_component_els_pkc_standalone_gdet true)
set(CONFIG_USE_component_els_pkc_els true)
set(CONFIG_USE_component_els_pkc_hash true)
set(CONFIG_USE_component_els_pkc_hashmodes true)
set(CONFIG_USE_component_els_pkc_hmac true)
set(CONFIG_USE_component_els_pkc_key true)
set(CONFIG_USE_component_els_pkc_mac true)
set(CONFIG_USE_component_els_pkc_mac_modes true)
set(CONFIG_USE_component_els_pkc_math true)
set(CONFIG_USE_component_els_pkc_memory true)
set(CONFIG_USE_component_els_pkc_padding true)
set(CONFIG_USE_component_els_pkc_pkc true)
set(CONFIG_USE_component_els_pkc_prng true)
set(CONFIG_USE_component_els_pkc_random true)
set(CONFIG_USE_component_els_pkc_random_modes true)
set(CONFIG_USE_component_els_pkc_random_modes_ctr true)
set(CONFIG_USE_component_els_pkc_rsa true)
set(CONFIG_USE_component_els_pkc_session true)
set(CONFIG_USE_component_els_pkc_trng true)
set(CONFIG_USE_component_els_pkc_trng_type_rng4 true)
set(CONFIG_USE_component_els_pkc_pre_processor true)
set(CONFIG_USE_component_els_pkc_data_integrity true)
set(CONFIG_USE_component_els_pkc_flow_protection true)
set(CONFIG_USE_component_els_pkc_param_integrity true)
set(CONFIG_USE_component_els_pkc_secure_counter true)
set(CONFIG_USE_component_els_pkc true)
set(CONFIG_USE_component_els_pkc_toolchain true)
set(CONFIG_USE_component_els_pkc_platform_rw61x_inf_header_only true)
set(CONFIG_USE_component_els_pkc_platform_rw61x_interface_files true)
set(CONFIG_USE_component_els_pkc_platform_rw61x_standalone_clib_gdet_sensor true)
set(CONFIG_USE_component_els_pkc_platform_rw61x true)
set(CONFIG_USE_component_mflash_offchip true)
set(CONFIG_USE_driver_conn_fwloader true)
set(CONFIG_USE_middleware_wifi_template true)
set(CONFIG_USE_middleware_wifi_osa_free_rtos true)
set(CONFIG_USE_middleware_wifi_osa true)
set(CONFIG_USE_middleware_wifi_common_files true)
set(CONFIG_USE_middleware_wifi_net true)
set(CONFIG_USE_middleware_wifi_net_free_rtos true)
set(CONFIG_USE_middleware_wifi_net_free_rtos_iperf true)
set(CONFIG_USE_middleware_wifi_wifidriver true)
set(CONFIG_USE_middleware_wifi_wifidriver_softap true)
set(CONFIG_USE_middleware_wifi true)
set(CONFIG_USE_middleware_wifi_imu true)
set(CONFIG_USE_middleware_mbedtls_port_els_pkc_option true)
set(CONFIG_USE_middleware_mbedtls_port_els true)
set(CONFIG_USE_middleware_mbedtls true)
set(CONFIG_USE_middleware_mbedtls_port_els_pkc true)
set(CONFIG_USE_middleware_lwip true)
set(CONFIG_USE_middleware_lwip_sys_arch_dynamic true)
set(CONFIG_USE_middleware_lwip_apps_lwiperf true)
set(CONFIG_USE_middleware_lwip_apps_lwiperf_non_generated_lwipopts true)
set(CONFIG_USE_middleware_llhttp true)
set(CONFIG_USE_middleware_mcuboot_nxp_app_support true)
set(CONFIG_USE_middleware_freertos-kernel true)
set(CONFIG_USE_middleware_freertos-kernel_heap_4 true)
set(CONFIG_USE_middleware_freertos-kernel_cm33_non_trustzone true)
set(CONFIG_USE_middleware_freertos-kernel_extension true)
set(CONFIG_USE_middleware_freertos-kernel_config true)
set(CONFIG_USE_middleware_freertos_corehttp true)
set(CONFIG_CORE cm33)
set(CONFIG_DEVICE RW612)
set(CONFIG_BOARD frdmrw612)
set(CONFIG_KIT frdmrw612)
set(CONFIG_DEVICE_ID RW612)
set(CONFIG_FPU SP_FPU)
set(CONFIG_DSP NO_DSP)
set(CONFIG_CORE_ID cm33)
set(CONFIG_TRUSTZONE TZ)

set(CONFIG_USE_component_memfault_sdk true)
set(CONFIG_USE_component_memfault_sdk_metrics true)
set(CONFIG_USE_component_memfault_sdk_ports_freertos true)
set(CONFIG_USE_component_memfault_sdk_ports_mcuxsdk true)
