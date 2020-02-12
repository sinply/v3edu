onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L blk_mem_gen_v8_4_1 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.blk_wr8x4096 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {blk_wr8x4096.udo}

run -all

quit -force
