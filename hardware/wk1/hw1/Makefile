.PHONY: compile simulate clean
all: simulate

VERILOG_SRC := $(shell ls *.v)

compiled: $(VERILOG_SRC)
	iverilog -o compiled $(VERILOG_SRC) 

simulate: compiled
	vvp compiled

clean:
	rm -rf compiled dump.vcd
