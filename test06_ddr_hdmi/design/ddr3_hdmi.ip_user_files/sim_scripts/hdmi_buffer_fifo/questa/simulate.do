onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib hdmi_buffer_fifo_opt

do {wave.do}

view wave
view structure
view signals

do {hdmi_buffer_fifo.udo}

run -all

quit -force
