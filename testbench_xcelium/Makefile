FLAGS := -f filelist.txt -access +rwc -gui

all:
	cp ../hdl/*.v .
	cp ../hdl/*.sv .
	cp ../testbench_base/*.v .
	xrun $(FLAGS)