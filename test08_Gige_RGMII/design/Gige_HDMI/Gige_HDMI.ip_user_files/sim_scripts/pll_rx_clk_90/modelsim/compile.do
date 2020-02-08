vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../Gige_HDMI.srcs/sources_1/ip/pll_rx_clk_90/pll_rx_clk_90_clk_wiz.v" \
"../../../../Gige_HDMI.srcs/sources_1/ip/pll_rx_clk_90/pll_rx_clk_90.v" \


vlog -work xil_defaultlib \
"glbl.v"

