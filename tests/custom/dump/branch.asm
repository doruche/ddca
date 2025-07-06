
elf/branch.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	14d00093          	li	ra,333
   4:	14d00113          	li	sp,333
   8:	fe208ce3          	beq	ra,sp,0 <_start>

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	1941                	.insn	2, 0x1941
   2:	0000                	.insn	2, 0x0000
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <_end+0x8>
   c:	0000000f          	fence	unknown,unknown
  10:	7205                	.insn	2, 0x7205
  12:	3376                	.insn	2, 0x3376
  14:	6932                	.insn	2, 0x6932
  16:	7032                	.insn	2, 0x7032
  18:	0031                	.insn	2, 0x0031
