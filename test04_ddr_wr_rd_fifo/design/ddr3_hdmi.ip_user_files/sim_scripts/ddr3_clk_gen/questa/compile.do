vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../ddr3_hdmi.srcs/sources_1/ip/ddr3_clk_gen/ddr3_clk_gen_clk_wiz.v" \
"../../../../ddr3_hdmi.srcs/sources_1/ip/ddr3_clk_gen/ddr3_clk_gen.v" \


vlog -work xil_defaultlib \
"glbl.v"

