.PHONY: run
run:
	@ [ -f hdl.var ] || touch hdl.var
	xmvhdl -work ctu_can_fd_rtl -v200x -f filelist_vhd.txt 
	xmvlog -work worklib_sv -sv -nocopyright -f filelist_sv.txt
	xmelab -timescale '1ns/1ps' -access +rwc tb_top
	xmsim  -gui tb_top
