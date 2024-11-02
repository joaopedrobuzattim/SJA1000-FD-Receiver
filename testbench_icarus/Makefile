FLAGS := -gio-range-error -g2012 -gverilog-ams -Wall -Wno-timescale 

all:
	cp ../testbench_base/*.sv .
	cp ../hdl/*.sv .
	iverilog $(FLAGS) -o test.vvp  -c filelist.txt 
	vvp test.vvp
	gtkwave test.vcd
