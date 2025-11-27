pdfs:
	cd doc/pt-br; \
	../md2pdf; \
	cd ../en-us; \
	../md2pdf

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
