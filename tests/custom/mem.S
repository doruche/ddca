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
    lw x1, x
    lh x2, x
    lb x3, x
    lhu x4, x
    lbu x5, x
    add x6, x4, x5
    la x7, a
    la x8, b
    sw x6, 0(x7)
    sh x6, 4(x7)
    sb x6, 2(x8)
    lw x9, 0(x7)
    lh x10, 4(x7)
    lb x11, 2(x8)

    j loop

loop:
    j loop
