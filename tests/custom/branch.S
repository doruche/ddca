.section .text
.global _start
_start:
    addi x1, x0, 333
    addi x2, x0, 333
    beq x1, x2, _start