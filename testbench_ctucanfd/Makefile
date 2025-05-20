.PHONY: run run-gui

run:
	xrun -clean
	@ [ -f hdl.var ] || touch hdl.var
	xmvhdl -log logs/xmvhdl.log  -work ctu_can_fd_rtl -v200x -f filelist_vhd.txt 
	xmvlog -log logs/xmvlog.log -work worklib_sv -sv -nocopyright -f filelist_sv.txt
	xmelab -log logs/xmelab.log -timescale '1ns/1ps' -access +rwc tb_top
	xmsim  -log logs/xmsim.log tb_top

run-gui:
	xrun -clean
	@ [ -f hdl.var ] || touch hdl.var
	xmvhdl -log logs/xmvhdl.log  -work ctu_can_fd_rtl -v200x -f filelist_vhd.txt 
	xmvlog -log logs/xmvlog.log -work worklib_sv -sv -nocopyright -f filelist_sv.txt
	xmelab -log logs/xmelab.log -timescale '1ns/1ps' -access +rwc tb_top
	xmsim  -log logs/xmsim.log -gui tb_top