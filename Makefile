CC = iverilog
CFLAGS = -g2012

PKGS = rtl/typepkg.svh

TB_SRCS = $(wildcard tb/*_tb.sv)
TB = $(patsubst tb/%.sv, tb/target/%, $(TB_SRCS))

.PHONY: top_tb tb clean

top_tb: tb/target/top_tb

tb: $(TB)

tb/target/%: tb/%.sv $(PKGS)
	@mkdir -p tb/target
# paths should be passed by caller of the script
	@$(CC) $(CFLAGS) -o $@ $(PKGS) $< -DBENCH -DROM_HEX=\"$(ROM_HEX_PATH)\" -DRAM_HEX=\"$(RAM_HEX_PATH)\"

clean:
	@rm -rf tb/target