# Adapted from riscvtest.s provided by DDCA book.
# [0x1004] should be 0x19 if the processor is working correctly.

.section .text
.global _start
_start:
    addi    x2, x0, 5
    addi    x3, x0, 12
    addi    x7, x3, -9
    or      x4, x7, x2
    and     x5, x3, x4
    add     x5, x5, x4
    beq     x5, x7, end
    slt     x4, x3, x4
    beq     x4, x0, around
    addi    x5, x0, 0
around:
    slt     x4, x7, x2
    add     x7, x4, x5
    sub     x7, x7, x2

    # before: x3 = 12, x7 = 7, x4 = 1
    addi    x3, x3, 2000
    addi    x3, x3, 2000
    addi    x4, x4, 2000
    addi    x4, x4, 2000
    # now x3 = 4012, x4 = 4001

    sw      x7, 84(x3)
    lw      x2, 95(x4)
    add     x9, x2, x5
    jal     x3, end
    addi    x2, x0, 1
end:
    add     x2, x2, x9
    # x3 = 0x54 = 84
    addi    x3, x3, 2000
    addi    x3, x3, 2000

    sw      x2, 16(x3)
done:
    beq     x2, x2, done

.section .data
x: .word 0
y: .word 0