vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../gige_tx_frame.srcs/sources_1/ip/blk_wr8x4096/sim/blk_wr8x4096.v" \


vlog -work xil_defaultlib \
"glbl.v"

