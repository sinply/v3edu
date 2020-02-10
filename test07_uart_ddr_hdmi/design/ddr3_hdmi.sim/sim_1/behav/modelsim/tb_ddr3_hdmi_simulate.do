######################################################################
#
# File name : tb_ddr3_hdmi_simulate.do
# Created on: Thu Feb 06 16:16:37 +0800 2020
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
vsim -voptargs="+acc" -L fifo_generator_v13_2_2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.tb_ddr3_hdmi xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {tb_ddr3_hdmi_wave.do}

view wave
view structure
view signals

do {tb_ddr3_hdmi.udo}

run 1000ns