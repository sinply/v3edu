-makelib xcelium_lib/xil_defaultlib -sv \
  "D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/ProgramData/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_1 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../gige_tx_frame.srcs/sources_1/ip/bram_wr8x256/sim/bram_wr8x256.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

