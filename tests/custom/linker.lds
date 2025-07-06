/*
for test programs, we assume a one-page-size memory space,
both for text and data.
*/

OUTPUT_ARCH(riscv)
ENTRY(_start)


SECTIONS
{
    . = 0x000;
    .text : {
        *(.text)
        *(.text.*)
    }
    .rodata : {
        *(.rodata)
        *(.rodata.*)  
    }
    .data : {
        *(.data)
        *(.data.*)
    }
    .bss : {
        *(.bss)
        *(.bss.*)
        *(.sbss)
        *(.sbss.*)
    }
    _end = .;
}