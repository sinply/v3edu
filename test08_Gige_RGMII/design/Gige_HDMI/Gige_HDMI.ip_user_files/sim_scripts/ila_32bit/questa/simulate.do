onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ila_32bit_opt

do {wave.do}

view wave
view structure
view signals

do {ila_32bit.udo}

run -all

quit -force
