-makelib ies_lib/xil_defaultlib -sv \
  "E:/Material/FPGA/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "E:/Material/FPGA/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../ddr3_hdmi.srcs/sources_1/ip/ddr3_clk_gen/ddr3_clk_gen_clk_wiz.v" \
  "../../../../ddr3_hdmi.srcs/sources_1/ip/ddr3_clk_gen/ddr3_clk_gen.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

