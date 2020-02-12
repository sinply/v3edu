onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib pll_clk_125_opt

do {wave.do}

view wave
view structure
view signals

do {pll_clk_125.udo}

run -all

quit -force
