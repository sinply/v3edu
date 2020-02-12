vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../gige_tx_frame.srcs/sources_1/ip/pll_clk_125/pll_clk_125_clk_wiz.v" \
"../../../../gige_tx_frame.srcs/sources_1/ip/pll_clk_125/pll_clk_125.v" \


vlog -work xil_defaultlib \
"glbl.v"

