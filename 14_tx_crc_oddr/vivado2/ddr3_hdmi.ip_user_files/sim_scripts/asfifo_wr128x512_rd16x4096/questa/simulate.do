onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib asfifo_wr128x512_rd16x4096_opt

do {wave.do}

view wave
view structure
view signals

do {asfifo_wr128x512_rd16x4096.udo}

run -all

quit -force
