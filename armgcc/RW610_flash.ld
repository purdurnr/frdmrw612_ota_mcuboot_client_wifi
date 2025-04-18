/*
** ###################################################################
**     Processors:          RW612ETA1I
**                          RW612HNA1I
**                          RW612UKA1I
**
**     Compiler:            GNU C Compiler
**     Reference manual:    RW61X User manual Rev. 0.95, June 2022
**     Version:             rev. 1.0, 2021-03-16
**     Build:               b221116
**
**     Abstract:
**         Linker file for the GNU C Compiler
**
**     Copyright 2016 Freescale Semiconductor, Inc.
**     Copyright 2016-2022 NXP
**     All rights reserved.
**
**     SPDX-License-Identifier: BSD-3-Clause
**
**     http:                 www.nxp.com
**     mail:                 support@nxp.com
**
** ###################################################################
*/



/* Entry Point */
ENTRY(Reset_Handler)

HEAP_SIZE  = DEFINED(__heap_size__)  ? __heap_size__  : 0x200;
STACK_SIZE = DEFINED(__stack_size__) ? __stack_size__ : 0x200;
M_VECTOR_RAM_SIZE = DEFINED(__ram_vector_table__) ? 0x00000280 : 0;

/* Specify the memory areas */
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


/* Define output sections */
SECTIONS
{

  .flash_config :
  {
    . = ALIGN(4);
    FILL(0xFF)
    . = 0x400;
    __FLASH_BASE = .;
    KEEP(* (.flash_conf))     /* flash config section */
    . = 0x1000;
  } > m_flash_config

  /* The startup code goes first into internal ram */
  .interrupts :
  {
    . = ALIGN(4);
    __VECTOR_TABLE = .;
    __Vectors = .;
    KEEP(*(.isr_vector))     /* Startup code */
    FILL(0x00)
    . = 0x280;
  } > m_interrupts

  .text :
  {
    . = ALIGN(4);
    *(.rcs.*)
    *(.text)                 /* .text sections (code) */
    /* Exclude flash and frequently executed functions from XIP */
    *(EXCLUDE_FILE(
        *port.c.obj
        *portasm.c.obj
        *queue.c.obj
        *timers.c.obj
        *tasks.c.obj
        *inet_chksum.c.obj
        *ip4.c.obj
        *pbuf.c.obj
        *sys_arch.c.obj
        *tcp_out.c.obj
        *tcp_in.c.obj
        *mlan_11n_rxreorder.c.obj
        *mlan_wmm.c.obj
        *wifi.c.obj
        *wifi-imu.c.obj
        *fsl_adapter_rfimu.c.obj
        *fsl_cache.c.obj
        *fsl_os_abstraction_free_rtos.c.obj
        *mflash_drv.c.obj
        *fsl_flexspi.c.obj
    ) .text*)              /* .text* sections (code) */
    *(.rodata)               /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)              /* .rodata* sections (constants, strings, etc.) */
    *(.glue_7)               /* glue arm to thumb code */
    *(.glue_7t)              /* glue thumb to arm code */
    *(.eh_frame)
    KEEP (*(.init))
    KEEP (*(.fini))
    . = ALIGN(4);
  } > m_text

  .ARM.extab :
  {
    *(.ARM.extab* .gnu.linkonce.armextab.*)
  } > m_text

  .ARM :
  {
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
  } > m_text

 .ctors :
  {
    __CTOR_LIST__ = .;
    /* gcc uses crtbegin.o to find the start of
       the constructors, so we make sure it is
       first.  Because this is a wildcard, it
       doesn't matter if the user does not
       actually link against crtbegin.o; the
       linker won't look for a file to match a
       wildcard.  The wildcard also means that it
       doesn't matter which directory crtbegin.o
       is in.  */
    KEEP (*crtbegin.o(.ctors))
    KEEP (*crtbegin?.o(.ctors))
    /* We don't want to include the .ctor section from
       from the crtend.o file until after the sorted ctors.
       The .ctor section from the crtend file contains the
       end of ctors marker and it must be last */
    KEEP (*(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
    __CTOR_END__ = .;
  } > m_text

  .dtors :
  {
    __DTOR_LIST__ = .;
    KEEP (*crtbegin.o(.dtors))
    KEEP (*crtbegin?.o(.dtors))
    KEEP (*(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
    __DTOR_END__ = .;
  } > m_text

  .preinit_array :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } > m_text

  .init_array :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
  } > m_text

  .fini_array :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array*))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } > m_text

  __etext = .;    /* define a global symbol at end of code */
  __DATA_ROM = .; /* Symbol is used by startup for data initialization */

  .interrupts_ram :
  {
    . = ALIGN(4);
    __VECTOR_RAM__ = .;
    __interrupts_ram_start__ = .; /* Create a global symbol at data start */
    *(.m_interrupts_ram)     /* This is a user defined section */
    . += M_VECTOR_RAM_SIZE;
    . = ALIGN(4);
    __interrupts_ram_end__ = .; /* Define a global symbol at data end */
  } > m_data

  __VECTOR_RAM = DEFINED(__ram_vector_table__) ? __VECTOR_RAM__ : ORIGIN(m_interrupts);
  __RAM_VECTOR_TABLE_SIZE_BYTES = DEFINED(__ram_vector_table__) ? (__interrupts_ram_end__ - __interrupts_ram_start__) : 0x0;

  .data : AT(__DATA_ROM)
  {
    . = ALIGN(4);
    __DATA_RAM = .;
    __data_start__ = .;      /* create a global symbol at data start */
    *(CodeQuickAccess)       /* CodeQuickAccess sections */
    *(DataQuickAccess)       /* DataQuickAccess sections */
    *(.data)                 /* .data sections */
    *(.data*)                /* .data* sections */
    *port.c.obj(.text*)
    *portasm.c.obj(.text*)
    *queue.c.obj(.text*)
    *timers.c.obj(.text*)
    *tasks.c.obj(.text*)
    *inet_chksum.c.obj(.text*)
    *ip4.c.obj(.text*)
    *pbuf.c.obj(.text*)
    *sys_arch.c.obj(.text*)
    *tcp_out.c.obj(.text*)
    *tcp_in.c.obj(.text*)
    *mlan_11n_rxreorder.c.obj(.text*)
    *mlan_wmm.c.obj(.text*)
    *wifi.c.obj(.text*)
    *wifi-imu.c.obj(.text*)
    *fsl_adapter_rfimu.c.obj(.text*)
    *fsl_cache.c.obj(.text*)
    *fsl_os_abstraction_free_rtos.c.obj(.text*)
    *mflash_drv.c.obj(.text .text* .rodata .rodata*)
    *fsl_flexspi.c.obj(.text .text* .rodata .rodata*)
    KEEP(*(.jcr*))
    . = ALIGN(4);
    __data_end__ = .;        /* define a global symbol at data end */
  } > m_data

  __DATA_END = __DATA_ROM + (__data_end__ - __data_start__);
  text_end = ORIGIN(m_text) + LENGTH(m_text);
  ASSERT(__DATA_END <= text_end, "region m_text overflowed with text and data")
  _image_size = __DATA_END - __VECTOR_TABLE;

  /* Uninitialized data section */
  .bss :
  {
    /* This is used by the startup in order to initialize the .bss section */
    . = ALIGN(4);
    __START_BSS = .;
    __bss_start__ = .;
    __memfault_capture_bss_start = .;
    */tasks.c.obj(.bss COMMON .bss*)
    */timers.c.obj(.bss COMMON .bss*)
    __memfault_capture_bss_end = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    __bss_end__ = .;
    __END_BSS = .;
  } > m_data

  .heap :
  {
    . = ALIGN(8);
    __end__ = .;
    PROVIDE(end = .);
    __HeapBase = .;
    . += HEAP_SIZE;
    __HeapLimit = .;
    __heap_limit = .; /* Add for _sbrk */
  } > m_data

  .stack :
  {
    . = ALIGN(8);
    . += STACK_SIZE;
  } > m_data

  /* Initializes stack on the end of block */
  __StackTop   = ORIGIN(m_data) + LENGTH(m_data);
  __StackLimit = __StackTop - STACK_SIZE;
  PROVIDE(__stack = __StackTop);

  .ARM.attributes 0 : { *(.ARM.attributes) }

  ASSERT(__StackLimit >= __HeapLimit, "region m_data overflowed with stack and heap")

  .smu_cpu13_mbox (NOLOAD) :
  {
    . = ALIGN(4);
    *(.smu_cpu13_mbox)
    KEEP (*(.smu_cpu13_mbox))
    . = ALIGN(4);
  } > m_mbox1

  .smu_cpu31_txq (NOLOAD) :
  {
    . = ALIGN(4);
    *(.smu_cpu31_txq)
    KEEP (*(.smu_cpu31_txq))
    . = ALIGN(4);
  } > m_txq1

  .smu_cpu23_mbox (NOLOAD) :
  {
    . = ALIGN(4);
    *(.smu_cpu23_mbox)
    KEEP (*(.smu_cpu23_mbox))
    . = ALIGN(4);
  } > m_mbox2

  .smu_cpu32_txq (NOLOAD) :
  {
    . = ALIGN(4);
    *(.smu_cpu32_txq)
    KEEP (*(.smu_cpu32_txq))
    . = ALIGN(4);
  } > m_txq2
}

