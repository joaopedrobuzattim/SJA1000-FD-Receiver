FLAGS := -f filelist.txt -access +rwc -gui

all:
	rm *.sv
	cp ../hdl/*.sv .
	cp ../testbench_base/*.sv .
	xrun $(FLAGS)