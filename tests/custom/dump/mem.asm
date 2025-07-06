
elf/mem.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	04002083          	lw	ra,64(zero) # 40 <mem>
   4:	04001103          	lh	sp,64(zero) # 40 <mem>
   8:	04000183          	lb	gp,64(zero) # 40 <mem>
   c:	04005203          	lhu	tp,64(zero) # 40 <mem>
  10:	04004283          	lbu	t0,64(zero) # 40 <mem>
  14:	00520333          	add	t1,tp,t0
  18:	04400393          	li	t2,68
  1c:	04800413          	li	s0,72
  20:	0063a023          	sw	t1,0(t2)
  24:	00639223          	sh	t1,4(t2)
  28:	00640123          	sb	t1,2(s0)
  2c:	0003a483          	lw	s1,0(t2)
  30:	00439503          	lh	a0,4(t2)
  34:	00240583          	lb	a1,2(s0)
  38:	0040006f          	j	3c <loop>

0000003c <loop>:
  3c:	0000006f          	j	3c <loop>

Disassembly of section .data:

00000040 <mem>:
  40:	f2f1                	.insn	2, 0xf2f1
  42:	          	.insn	4, 0xf4f3

00000044 <a>:
  44:	0000                	.insn	2, 0x0000
	...

00000048 <b>:
	...

0000004a <c>:
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	1941                	.insn	2, 0x1941
   2:	0000                	.insn	2, 0x0000
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <_start+0x14>
   c:	0000000f          	fence	unknown,unknown
  10:	7205                	.insn	2, 0x7205
  12:	3376                	.insn	2, 0x3376
  14:	6932                	.insn	2, 0x6932
  16:	7032                	.insn	2, 0x7032
  18:	0031                	.insn	2, 0x0031
