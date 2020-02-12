// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : tb_gige.v
// Create : 2020-02-10 21:08:36
// Revise : 2020-02-12 16:07:21
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module tb_gige(
    );

	reg 		srst;
	reg 		clk;
	wire 		tx_c_90;
	wire 		tx_dv;
	wire [3:0]	tx_d;

	// clock
	initial begin
		clk = 0;
		forever #(4) clk = ~clk;
	end

	// reset
	initial begin
		srst <= 1;
		#20
		repeat (10) @(posedge clk);
		srst <= 0;
	end

	top_gige #(
		.SIM_FLAG(1)
	) inst_top_gige (
		.tx_clk  (clk),
		.rst     (srst),
		.tx_c_90 (tx_c_90),
		.tx_d    (tx_d),
		.tx_dv   (tx_dv)
	);

endmodule
