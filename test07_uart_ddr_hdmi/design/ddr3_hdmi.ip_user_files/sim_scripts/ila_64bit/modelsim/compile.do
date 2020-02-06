vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../ddr3_hdmi.srcs/sources_1/ip/ila_64bit/hdl/verilog" "+incdir+../../../../ddr3_hdmi.srcs/sources_1/ip/ila_64bit/hdl/verilog" \
"../../../../ddr3_hdmi.srcs/sources_1/ip/ila_64bit/sim/ila_64bit.v" \


vlog -work xil_defaultlib \
"glbl.v"

