CROSS = riscv32-unknown-elf-
CC = $(CROSS)gcc
OBJDUMP = $(CROSS)objdump
OBJCOPY = $(CROSS)objcopy

CFLAGS = -march=rv32i -mabi=ilp32 -O0 -Wall -nostdlib -nostartfiles -ffreestanding -fno-builtin -Tlinker.lds

HEX_DIR = hex
ELF_DIR = elf
BIN_DIR = bin
DUMP_DIR = dump

PROG_SRCS = $(wildcard *.S)
ELFS = $(patsubst %.S,$(ELF_DIR)/%.elf,$(PROG_SRCS))
ROMS_BIN = $(patsubst %.S,$(BIN_DIR)/%_rom.bin,$(PROG_SRCS))
RAMS_BIN = $(patsubst %.S,$(BIN_DIR)/%_ram.bin,$(PROG_SRCS))
ROMS_HEX = $(patsubst %.S,$(HEX_DIR)/%_rom.hex,$(PROG_SRCS))
RAMS_HEX = $(patsubst %.S,$(HEX_DIR)/%_ram.hex,$(PROG_SRCS))
ROMS = $(ROMS_BIN) $(ROMS_HEX)
RAMS = $(RAMS_BIN) $(RAMS_HEX)
DUMPS = $(patsubst %.S,$(DUMP_DIR)/%.asm,$(PROG_SRCS))

.PHONY: all clean

all: $(ELFS) $(ROMS) $(RAMS) $(DUMPS)

$(HEX_DIR)/%_rom.hex: $(BIN_DIR)/%_rom.bin
	@mkdir -p $(HEX_DIR)
	@python ../bin2hex.py $< $@

$(HEX_DIR)/%_ram.hex: $(BIN_DIR)/%_ram.bin
	@mkdir -p $(HEX_DIR)
	@python ../bin2hex.py $< $@

$(BIN_DIR)/%_ram.bin: $(ELF_DIR)/%.elf
	@mkdir -p $(BIN_DIR)
	@$(OBJCOPY) -O binary -j .data $< $@

$(BIN_DIR)/%_rom.bin: $(ELF_DIR)/%.elf
	@mkdir -p $(BIN_DIR)
	@$(OBJCOPY) -O binary -j .text $< $@

$(DUMP_DIR)/%.asm: $(ELF_DIR)/%.elf
	@mkdir -p $(DUMP_DIR)
	@$(OBJDUMP) -D $< > $@

$(ELF_DIR)/%.elf: %.S
	@mkdir -p $(ELF_DIR)
	@$(CC) $(CFLAGS) -o $@ $<

clean:
	@rm -rf $(HEX_DIR) $(ELF_DIR) $(DUMP_DIR) $(BIN_DIR)
	@echo "Cleaned up generated files."