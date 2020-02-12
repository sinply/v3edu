vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../gige_tx_frame.srcs/sources_1/ip/clk_125_gen/clk_125_gen_clk_wiz.v" \
"../../../../gige_tx_frame.srcs/sources_1/ip/clk_125_gen/clk_125_gen.v" \


vlog -work xil_defaultlib \
"glbl.v"

