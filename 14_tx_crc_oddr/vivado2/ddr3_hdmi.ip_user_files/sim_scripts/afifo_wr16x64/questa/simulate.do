onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib afifo_wr16x64_opt

do {wave.do}

view wave
view structure
view signals

do {afifo_wr16x64.udo}

run -all

quit -force
