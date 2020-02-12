vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../ddr3_hdmi.srcs/sources_1/ip/hdmi_clk_gen/hdmi_clk_gen_clk_wiz.v" \
"../../../../ddr3_hdmi.srcs/sources_1/ip/hdmi_clk_gen/hdmi_clk_gen.v" \


vlog -work xil_defaultlib \
"glbl.v"

