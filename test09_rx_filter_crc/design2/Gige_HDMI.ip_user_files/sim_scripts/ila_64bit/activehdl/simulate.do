onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+ila_64bit -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ila_64bit xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {ila_64bit.udo}

run -all

endsim

quit -force
