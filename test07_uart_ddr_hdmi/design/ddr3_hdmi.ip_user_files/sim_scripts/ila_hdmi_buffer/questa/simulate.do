onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ila_hdmi_buffer_opt

do {wave.do}

view wave
view structure
view signals

do {ila_hdmi_buffer.udo}

run -all

quit -force
