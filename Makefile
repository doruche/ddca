CC = iverilog
CFLAGS = -g2012

PKGS = rtl/typepkg.svh

TB_SRCS = $(wildcard tb/*_tb.sv)
TB = $(patsubst tb/%.sv, tb/target/%, $(TB_SRCS))

.PHONY: top_tb tb custom clean

top_tb: tb/target/top_tb

tb: $(TB)

tb/target/%: tb/%.sv $(PKGS)
	@mkdir -p tb/target
	@$(CC) $(CFLAGS) -o $@ $(PKGS) $< -DBENCH

custom:
	@cd tests/custom && make

clean:
	@rm -rf tb/target
	@echo "All builds cleaned."