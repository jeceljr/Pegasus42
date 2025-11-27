PDFs := $(shell find . -name '*.pdf')

PDF_DEP := $(PDFs:Pegasus42.pdf=README.md)
PDF_DEP += $(PDFs:Pegasus42.pdf=1.comb.md)
PDF_DEP += $(PDFs:Pegasus42.pdf=2.seq.md)
PDF_DEP += $(PDFs:Pegasus42.pdf=3.cpu.md)
PDF_DEP += $(PDFs:Pegasus42.pdf=4.fpga.md)
PDF_DEP += $(PDFs:Pegasus42.pdf=5.av.md)
PDF_DEP += $(PDFs:Pegasus42.pdf=6.pegasus42.md)
PDF_DEP += $(PDFs:Pegasus42.pdf=A.hist.md)


%.pdf: $(PDF_DEP)
	cd $(@D); ../md2pdf

HEX_DIR := ./hex
SRC_DIR := ./soft

MCPUSRC := $(shell find $(SRC_DIR) -name '*.S')
RVSRC := $(shell find $(SRC_DIR) -name '*.s')

MCPUHEX := $(MCPUSRC:$(SRC_DIR)%.S=$(HEX_DIR)%.hex)
RVHEX := $(RVSRC:$(SRC_DIR)%.s=$(HEX_DIR)%.hex)

ALLHEX: $(MCPUHEX) $(RVHEX)

%.hex: ../$(SRC_DIR)/%.S mcpu16.inc
	as -a -o tmp.o $<
	objcopy -S -O ihex tmp.o $@
	rm tmp.o

%.hex: ../$(SRC_DIR)/%.s
	riscv32-unknown-linux-gnu-as -a -o tmp.o $<
	objcopy -S -O ihex tmp.o $@
	rm tmp.o

all: $(PDFs) $(ALLHEX)

