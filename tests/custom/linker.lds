OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY {
    PROGROM (rx) : ORIGIN = 0x00000000, LENGTH = 0x1000
    DATARAM (rw) : ORIGIN = 0x00001000, LENGTH = 0x2000
}

SECTIONS {
    . = 0;

    .text : {
        *(.text)
        *(.text.*)
    } > PROGROM

    .data : {
        . = ALIGN(4);
        *(.data)
        *(.data.*)
        *(.bss)
        *(.bss.*)
        *(.rodata)
        *(.rodata.*)
        *(.sdata)
        *(.sdata.*)
        *(.sbss)
        *(.sbss.*)
    } > DATARAM

    _end = .;
}