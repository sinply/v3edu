onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib cmd_fifo_ctrl_opt

do {wave.do}

view wave
view structure
view signals

do {cmd_fifo_ctrl.udo}

run -all

quit -force
