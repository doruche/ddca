// memory operation test program

.section .data
mem:
x: .word 0xf4f3f2f1
a: .skip 4
b: .skip 2
c: .skip 1

.section .text
.global _start
_start:
    li x31, 0x1000
    lw x1, 0(x31)
    lh x2, 0(x31)
    lb x3, 0(x31)
    lhu x4, 0(x31)
    lbu x5, 0(x31)
    add x6, x4, x5
    la x7, 0x1004
    la x8, 0x1008
    sw x6, 0(x7)
    sh x6, 4(x7)
    sb x6, 2(x8)
    lw x9, 0(x7)
    lh x10, 4(x7)
    lb x11, 2(x8)

    j loop

loop:
    j loop
