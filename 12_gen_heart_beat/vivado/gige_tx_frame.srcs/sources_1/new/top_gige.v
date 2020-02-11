// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : top_gige.v
// Create : 2020-02-10 20:32:15
// Revise : 2020-02-10 21:06:46
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module top_gige #(
		parameter SIM_FLAG = 0
	)
	(
		input 	wire 			tx_clk,
		input 	wire 			rst
    );

wire 			timer_pulse;
wire 			tx_en;
wire 	[7:0]	tx_data;

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


endmodule
