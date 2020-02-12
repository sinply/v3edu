-makelib ies_lib/xil_defaultlib -sv \
  "D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../gige_tx_frame.srcs/sources_1/ip/clk_125_gen/clk_125_gen_clk_wiz.v" \
  "../../../../gige_tx_frame.srcs/sources_1/ip/clk_125_gen/clk_125_gen.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

