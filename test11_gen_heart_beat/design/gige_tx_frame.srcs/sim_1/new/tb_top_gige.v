// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : tb_top_gige.v
// Create : 2020-02-11 14:42:39
// Revise : 2020-02-11 14:44:41
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module tb_top_gige();

	reg srst;
	reg clk;

	// clock
	initial begin
		clk = 0;
		forever #(4) clk = ~clk;
	end

	// reset
	initial begin
		srst <= 1;
		repeat (100) @(posedge clk);
		srst <= 0;
	end

	// (*NOTE*) replace reset, clock, others

	parameter SIM_FLAG = 1;

	top_gige #(
		.SIM_FLAG(SIM_FLAG)
		) 
	inst_top_gige (
		.clk(clk), 
		.rst(srst)
		);
endmodule
