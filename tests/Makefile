TESTS := $(wildcard test_*.v)
OUTS := $(TESTS:.v=)
DEPS := $(wildcard *.v ../hdl/can_*.v)
FLAGS := -gio-range-error -Wall -Wno-timescale

all: $(OUTS)

%: %.v FORCE
	iverilog $(FLAGS) -o $@ -s $@ -I ../hdl $< $(wildcard ../hdl/can_*.v)
	@echo === $@ ===
	@vvp $@

FORCE:
