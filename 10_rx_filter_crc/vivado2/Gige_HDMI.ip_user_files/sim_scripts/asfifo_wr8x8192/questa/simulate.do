onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib asfifo_wr8x8192_opt

do {wave.do}

view wave
view structure
view signals

do {asfifo_wr8x8192.udo}

run -all

quit -force
