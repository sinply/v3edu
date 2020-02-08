vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../Gige_HDMI.srcs/sources_1/ip/ila_32bit/hdl/verilog" "+incdir+../../../../Gige_HDMI.srcs/sources_1/ip/ila_32bit/hdl/verilog" \
"D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../Gige_HDMI.srcs/sources_1/ip/ila_32bit/hdl/verilog" "+incdir+../../../../Gige_HDMI.srcs/sources_1/ip/ila_32bit/hdl/verilog" \
"../../../../Gige_HDMI.srcs/sources_1/ip/ila_32bit/sim/ila_32bit.v" \

vlog -work xil_defaultlib \
"glbl.v"

