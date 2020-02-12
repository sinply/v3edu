vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../ddr3_hdmi.srcs/sources_1/ip/fifo_wr16x1024_rd128x128/sim/fifo_wr16x1024_rd128x128.v" \


vlog -work xil_defaultlib \
"glbl.v"

