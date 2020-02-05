vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../ddr3_hdmi.srcs/sources_1/ip/asfifo_wr128x512_rd16x4096/sim/asfifo_wr128x512_rd16x4096.v" \


vlog -work xil_defaultlib \
"glbl.v"

