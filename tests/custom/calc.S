.section .text
.global _start
_start:
    addi x7, x5, 333
    xori x31, x6, -42
    auipc x9, 777
    lui x4, 999
    jal x9, _start

.section .data
placeholder: .word 0xdeadbeef