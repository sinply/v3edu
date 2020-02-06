// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : hdmi_dis.v
// Create : 2020-02-05 14:17:17
// Revise : 2020-02-05 22:57:12
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module hdmi_dis(
	input 	wire 			clk1x,
	input 	wire			clk5x,
	input 	wire 			rst,
	input  	wire 			locked,
	// output 	wire 			fifo_rd_en,
	input	wire	[23:0]	rgb_pixel,	

	output 	wire 			vga_de,
	output 	wire 			vga_start,
	output	wire 			hdmi_clk_p,
	output	wire 			hdmi_clk_n,
	output	wire 			hdmi_d0_p,
	output	wire 			hdmi_d0_n,
	output	wire 			hdmi_d1_p,
	output	wire 			hdmi_d1_n,
	output	wire 			hdmi_d2_p,
	output	wire 			hdmi_d2_n
    );

wire[7:0]	vga_r;
wire[7:0]	vga_g;
wire[7:0]	vga_b;
wire 		v_sync;
wire 		h_sync;
wire 		po_de;

assign vga_de = po_de;

	VGA_TIMING inst_VGA_TIMING (
			.sclk       (clk1x),
			.rst_n      (~rst),
			.po_vga_r   (vga_r),
			.po_vga_g   (vga_g),
			.po_vga_b   (vga_b),
			.po_de      (po_de),
			.po_v_sync  (v_sync),
			.po_h_sync  (h_sync),
			.vga_start  (vga_start),
			.rgb_pixel  (rgb_pixel)//,
			// .rd_fifo_en (fifo_rd_en)
		);


	hdmi_trans inst_hdmi_trans
	(
		.clk1x       (clk1x),
		.clk5x       (clk5x),
		.rst         (rst),
		.locked      (locked),
		.vga_r       (vga_r),
		.vga_g       (vga_g),
		.vga_b       (vga_b),
		.de          (po_de),
		.v_sync      (v_sync),
		.h_sync      (h_sync),
		.hdmi_clk_p  (hdmi_clk_p),
		.hdmi_clk_n  (hdmi_clk_n),
		.hdmi_chn0_p (hdmi_d0_p),
		.hdmi_chn0_n (hdmi_d0_n),
		.hdmi_chn1_p (hdmi_d1_p),
		.hdmi_chn1_n (hdmi_d1_n),
		.hdmi_chn2_p (hdmi_d2_p),
		.hdmi_chn2_n (hdmi_d2_n)
	);


endmodule
