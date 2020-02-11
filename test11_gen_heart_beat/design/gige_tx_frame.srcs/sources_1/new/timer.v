// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : timer.v
// Create : 2020-02-11 14:02:59
// Revise : 2020-02-11 14:15:05
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module timer # (
	parameter 	SIM_FLAG = 0
	)
	(
	input 	wire 			clk,
	input 	wire 			rst,
	output 	reg  			timer_pulse
    );

localparam 	ONE_SEC		= 125000000-1,
			SIM_CNT 	= 2047;	

reg 	[27:0]	timer_cnt;

//timer_cnt
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		timer_cnt <= 'd0;
	else if (SIM_FLAG == 1'b0 && timer_cnt == ONE_SEC)
		timer_cnt <= 'd0;
	else if (SIM_FLAG == 1'b1 && timer_cnt == SIM_CNT)
		timer_cnt <= 'd0;
	else 
		timer_cnt <= timer_cnt + 1'b1;
end

//timer_pulse
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		timer_pulse <= 1'b0;
	else if (SIM_FLAG == 1'b0 && timer_cnt == ONE_SEC)
		timer_pulse <= 1'b1;
	else if (SIM_FLAG == 1'b1 && timer_cnt == SIM_CNT)
		timer_pulse <= 1'b1;
	else 
		timer_pulse <= 1'b0;
end

endmodule
