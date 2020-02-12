vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"E:/install_tools/xilinxvv/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/install_tools/xilinxvv/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"E:/install_tools/xilinxvv/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../ddr3_hdmi.srcs/sources_1/ip/clk_125_gen/clk_125_gen_clk_wiz.v" \
"../../../../ddr3_hdmi.srcs/sources_1/ip/clk_125_gen/clk_125_gen.v" \

vlog -work xil_defaultlib \
"glbl.v"

