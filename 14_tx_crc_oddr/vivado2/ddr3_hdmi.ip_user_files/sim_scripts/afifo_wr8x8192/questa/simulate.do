onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib afifo_wr8x8192_opt

do {wave.do}

view wave
view structure
view signals

do {afifo_wr8x8192.udo}

run -all

quit -force
