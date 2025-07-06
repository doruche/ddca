CC = iverilog
CFLAGS = -g2012

PKGS = rtl/typepkg.svh
# SRCS = rtl/core.sv \
# 	   rtl/insndec.sv \
# 	   rtl/immext.sv \
# 	   rtl/ctrl.sv \
# 	   rtl/regfiles.sv \
# 	   rtl/alu.sv	\
# 	   rtl/pc.sv	\
# 	   rtl/periph/mmodel.sv
TB_SRCS = $(wildcard tb/*_tb.sv)
TB = $(patsubst tb/%.sv, tb/target/%, $(TB_SRCS))

.PHONY: top tb clean

top: tb/target/rv32i_tb

tb: $(TB)

tb/target/%: tb/%.sv $(PKGS)
	@mkdir -p tb/target
	@$(CC) $(CFLAGS) -o $@ $(PKGS) $< -DBENCH

clean:
	@rm *.vcd
	@rm -rf tb/target
	@echo "All builds cleaned."