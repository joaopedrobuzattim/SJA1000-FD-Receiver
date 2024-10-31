FLAGS_ICARUS := -gio-range-error -g2012 -gverilog-ams -Wall -Wno-timescale 
FLAGS_XRUN := -f filelist.txt -access +rwc -gui

.PHONY: run-xcelium
run-xcelium:
	xrun $(FLAGS_XRUN)

.PHONY: clean
clean:
	xrun -clean

.PHONY: run-icarus
run-icarus:
	iverilog $(FLAGS_ICARUS) -o test.vvp  -c filelist.txt 
	vvp test.vvp
	gtkwave test.vcd


.PHONY: gtk
gtk:
	gtkwave waveform.ghw