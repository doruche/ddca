include ../Common.mk

SRCS = $(wildcard *.S)
ELFS = $(SRCS:.S=.elf)
ROMS_BIN = $(SRCS:.S=_rom.bin)
RAMS_BIN = $(SRCS:.S=_ram.bin)
ROMS_HEX = $(SRCS:.S=_rom.hex)
RAMS_HEX = $(SRCS:.S=_ram.hex)
ROMS = $(ROMS_BIN) $(ROMS_HEX)
RAMS = $(RAMS_BIN) $(RAMS_HEX)
DUMPS = $(SRCS:.S=.asm)

.PHONY: all clean

all: $(ELFS) $(ROMS) $(RAMS) $(DUMPS)

%_rom.hex: %_rom.bin
	@$(BIN2HEX) $< $@

%_ram.hex: %_ram.bin
	@$(BIN2HEX) $< $@

%_rom.bin: %.elf
	@$(OBJCOPY) -O binary -j .text $< $@

%_ram.bin: %.elf
	@$(OBJCOPY) -O binary -j .data $< $@

%.asm: %.elf
	@$(OBJDUMP) -D $< > $@

%.elf: %.S
	@$(CC) $(CFLAGS) -o $@ $<

clean:
	@rm -f $(ELFS) $(ROMS) $(RAMS) $(DUMPS)