onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib wr_data_fifo_ctrl_opt

do {wave.do}

view wave
view structure
view signals

do {wr_data_fifo_ctrl.udo}

run -all

quit -force
