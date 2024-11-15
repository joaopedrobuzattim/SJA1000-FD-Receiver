FLAGS := -gio-range-error -g2012 -gverilog-ams -Wall -Wno-timescale 

all:
	iverilog $(FLAGS) -o test.vvp  -c filelist.txt 
	vvp test.vvp
	gtkwave test.vcd
