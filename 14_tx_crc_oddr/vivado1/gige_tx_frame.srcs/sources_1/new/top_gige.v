// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : top_gige.v
// Create : 2020-02-10 20:32:15
// Revise : 2020-02-12 16:02:40
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module top_gige #(
		parameter SIM_FLAG = 0
	)
	(
		input 	wire 			tx_clk,
		input 	wire 			rst,
		output 	wire 			tx_c_90,
		output 	wire 	[3:0]	tx_d,
		output 	wire 			tx_dv
    );

wire 			timer_pulse;
wire 			tx_en;
wire 	[7:0]	tx_data;
wire 			dsin;
wire 	[7:0]	din;
wire 			pre_flag;
wire 			dsout;
wire 	[7:0]	dout;

timer #(
		.SIM_FLAG(SIM_FLAG)
	) inst_timer (
		.tx_clk      (tx_clk),
		.rst         (rst),
		.timer_pulse (timer_pulse)
	);

	gen_frame_ctrl inst_gen_frame_ctrl (
			.tx_clk      (tx_clk),
			.rst         (rst),
			.timer_pulse (timer_pulse),
			.tx_en       (tx_en),
			.tx_data     (tx_data)
		);

	checksum_ctrl inst_checksum_ctrl (
			.tx_clk      (tx_clk),
			.rst         (rst),
			.tx_gen_data (tx_data),
			.tx_data_en  (tx_en),
			.tx_en       (dsin),
			.tx_data     (din),
			.pre_flag 	 (pre_flag)
		);

	crc32_d8_send_02 inst_crc32_d8_send_02
	(
		.rst        (rst),
		.sclk       (tx_clk),
		.dsin       (dsin),
		.din        (din),
		.pre_flag   (pre_flag),
		.crc_err_en (1'b0),
		.dsout      (dsout),
		.dout       (dout)
	);

	oddr_ctrl inst_oddr_ctrl
	(
			.sclk    (tx_clk),
			.tx_dat  (dout),
			.tx_en   (dsout),
			.tx_c    (tx_clk),
			.tx_data (tx_d),
			.tx_dv   (tx_dv),
			.tx_clk  (tx_c_90)
		);


endmodule
