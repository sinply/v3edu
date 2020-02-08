-makelib xcelium_lib/xil_defaultlib -sv \
  "D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../Gige_HDMI.srcs/sources_1/ip/pll_rx_clk_90/pll_rx_clk_90_clk_wiz.v" \
  "../../../../Gige_HDMI.srcs/sources_1/ip/pll_rx_clk_90/pll_rx_clk_90.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

