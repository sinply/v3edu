onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clk_125_gen_opt

do {wave.do}

view wave
view structure
view signals

do {clk_125_gen.udo}

run -all

quit -force
