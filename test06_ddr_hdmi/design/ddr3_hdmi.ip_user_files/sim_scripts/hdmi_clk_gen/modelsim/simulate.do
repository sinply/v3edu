onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.hdmi_clk_gen xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {hdmi_clk_gen.udo}

run -all

quit -force
