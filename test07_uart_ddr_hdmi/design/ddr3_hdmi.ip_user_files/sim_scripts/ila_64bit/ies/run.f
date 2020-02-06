-makelib ies_lib/xil_defaultlib -sv \
  "D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../ddr3_hdmi.srcs/sources_1/ip/ila_64bit/sim/ila_64bit.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

