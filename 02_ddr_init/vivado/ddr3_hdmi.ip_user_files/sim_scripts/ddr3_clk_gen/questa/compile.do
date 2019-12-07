vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"E:/Material/FPGA/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93 \
"E:/Material/FPGA/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../ddr3_hdmi.srcs/sources_1/ip/ddr3_clk_gen/ddr3_clk_gen_clk_wiz.v" \
"../../../../ddr3_hdmi.srcs/sources_1/ip/ddr3_clk_gen/ddr3_clk_gen.v" \

vlog -work xil_defaultlib \
"glbl.v"

