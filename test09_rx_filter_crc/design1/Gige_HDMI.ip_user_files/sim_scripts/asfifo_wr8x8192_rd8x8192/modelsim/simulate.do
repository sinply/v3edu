onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L fifo_generator_v13_2_2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.asfifo_wr8x8192_rd8x8192 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {asfifo_wr8x8192_rd8x8192.udo}

run -all

quit -force
