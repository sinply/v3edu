vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../Gige_HDMI.srcs/sources_1/ip/asfifo_wr8x8192/sim/asfifo_wr8x8192.v" \


vlog -work xil_defaultlib \
"glbl.v"

