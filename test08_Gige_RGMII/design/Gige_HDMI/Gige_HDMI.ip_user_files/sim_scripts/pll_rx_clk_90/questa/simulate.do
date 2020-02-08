onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib pll_rx_clk_90_opt

do {wave.do}

view wave
view structure
view signals

do {pll_rx_clk_90.udo}

run -all

quit -force
