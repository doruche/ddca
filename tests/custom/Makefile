CROSS = riscv32-unknown-elf-
CC = $(CROSS)gcc
OBJDUMP = $(CROSS)objdump
OBJCOPY = $(CROSS)objcopy

CFLAGS = -march=rv32i -mabi=ilp32 -O0 -Wall -nostdlib -nostartfiles -ffreestanding -fno-builtin -Tlinker.lds

HEX_DIR = hex
ELF_DIR = elf
DUMP_DIR = dump

PROG_SRCS = $(wildcard *.S)
PROGS = $(patsubst %.S,$(HEX_DIR)/%.hex,$(PROG_SRCS))
DUMPS = $(patsubst %.S,$(DUMP_DIR)/%.asm,$(PROG_SRCS))

.PHONY: all clean

all: $(PROGS) $(DUMPS)

$(HEX_DIR)/%.hex: $(ELF_DIR)/%.elf
	@mkdir -p $(HEX_DIR)
	@$(OBJCOPY) -O verilog $< $@

$(DUMP_DIR)/%.asm: $(ELF_DIR)/%.elf
	@mkdir -p $(DUMP_DIR)
	@$(OBJDUMP) -D $< > $@

$(ELF_DIR)/%.elf: %.S
	@mkdir -p $(ELF_DIR)
	@$(CC) $(CFLAGS) -o $@ $<

clean:
	@rm -rf $(HEX_DIR) $(ELF_DIR) $(DUMP_DIR)
	@echo "Cleaned up generated files."