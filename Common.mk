CC = iverilog
CFLAGS = -g2012 -I $(ROOTDIR)
OUTDIR = compiled
TBDIR = tb

ROOTDIR = ..

TB_SRCS = $(wildcard $(TBDIR)/*.sv)
TBS = $(patsubst $(TBDIR)/%.sv, $(OUTDIR)/%.vvp, $(TB_SRCS))

all: $(TBS)
	@echo ">>>\t All testbenches compiled."

$(OUTDIR)/%.vvp: $(TBDIR)/%.sv | $(OUTDIR)
	@echo ">>>\t Compiling $<..."
	@$(CC) $(CFLAGS) -o $@ $<

$(OUTDIR):
	@mkdir -p $(OUTDIR)

clean:
	@rm -rf $(OUTDIR)
	@echo ">>>\t Cleaned up."

.PHONY: all clean