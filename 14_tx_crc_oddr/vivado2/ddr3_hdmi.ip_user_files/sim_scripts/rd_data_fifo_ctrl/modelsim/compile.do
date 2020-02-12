vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../ddr3_hdmi.srcs/sources_1/ip/rd_data_fifo_ctrl/sim/rd_data_fifo_ctrl.v" \


vlog -work xil_defaultlib \
"glbl.v"

