vlib work
vlib riviera

vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../Gige_HDMI.srcs/sources_1/ip/clk_125_gen/clk_125_gen_clk_wiz.v" \
"../../../../Gige_HDMI.srcs/sources_1/ip/clk_125_gen/clk_125_gen.v" \


vlog -work xil_defaultlib \
"glbl.v"

