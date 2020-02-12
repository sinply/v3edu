-makelib xcelium_lib/xil_defaultlib -sv \
  "E:/install_tools/xilinxvv/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "E:/install_tools/xilinxvv/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "E:/install_tools/xilinxvv/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../ddr3_hdmi.srcs/sources_1/ip/clk_125_gen/clk_125_gen_clk_wiz.v" \
  "../../../../ddr3_hdmi.srcs/sources_1/ip/clk_125_gen/clk_125_gen.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

