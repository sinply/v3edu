onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.ila_64bit xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {ila_64bit.udo}

run -all

quit -force
