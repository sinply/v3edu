onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.ddr3_ctrl xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {ddr3_ctrl.udo}

run -all

quit -force
