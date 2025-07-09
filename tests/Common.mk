CROSS = riscv32-unknown-elf-
CC = $(CROSS)gcc
OBJDUMP = $(CROSS)objdump
OBJCOPY = $(CROSS)objcopy

CFLAGS = -march=rv32i \
		 -mabi=ilp32  \
		 -O0 \
		 -Wall \
		 -nostdlib \
		 -nostartfiles \
		 -ffreestanding \
		 -fno-builtin \
		 -T../linker.lds


BIN2HEX = python ../bin2hex.py