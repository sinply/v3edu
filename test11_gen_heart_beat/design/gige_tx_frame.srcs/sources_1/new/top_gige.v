// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : top_gige.v
// Create : 2020-02-11 14:37:45
// Revise : 2020-02-11 14:41:18
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module top_gige #(
	parameter 	SIM_FLAG = 0
	)
	(
		input 	wire 	clk,
		input 	wire 	rst
    );

wire 			timer_pulse;
wire 			tx_en;
wire 	[7:0]	tx_data;

timer #(
	.SIM_FLAG(SIM_FLAG)
	) 
inst_timer (
	.clk(clk),
	.rst(rst), 
	.timer_pulse(timer_pulse)
	);

	gen_frame_ctrl inst_gen_frame_ctrl (
			.clk         (clk),
			.rst         (rst),
			.timer_pulse (timer_pulse),
			.tx_en       (tx_en),
			.tx_data     (tx_data)
		);

endmodule
