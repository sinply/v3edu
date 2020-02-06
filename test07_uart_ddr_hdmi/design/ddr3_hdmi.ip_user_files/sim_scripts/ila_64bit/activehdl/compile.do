vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../ddr3_hdmi.srcs/sources_1/ip/ila_64bit/hdl/verilog" "+incdir+../../../../ddr3_hdmi.srcs/sources_1/ip/ila_64bit/hdl/verilog" \
"D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../ddr3_hdmi.srcs/sources_1/ip/ila_64bit/hdl/verilog" "+incdir+../../../../ddr3_hdmi.srcs/sources_1/ip/ila_64bit/hdl/verilog" \
"../../../../ddr3_hdmi.srcs/sources_1/ip/ila_64bit/sim/ila_64bit.v" \

vlog -work xil_defaultlib \
"glbl.v"

