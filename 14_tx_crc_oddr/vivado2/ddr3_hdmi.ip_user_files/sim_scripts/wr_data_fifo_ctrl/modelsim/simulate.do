onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L fifo_generator_v13_2_2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.wr_data_fifo_ctrl xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {wr_data_fifo_ctrl.udo}

run -all

quit -force
