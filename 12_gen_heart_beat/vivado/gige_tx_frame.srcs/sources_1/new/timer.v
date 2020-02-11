// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : timer.v
// Create : 2020-02-10 20:19:03
// Revise : 2020-02-10 20:31:16
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module timer #(
	parameter	SIM_FLAG = 0
	)
	(
	input	wire 			tx_clk,
	input 	wire 			rst,
	output 	wire 			timer_pulse
    );

parameter 	ONE_SEC = 125000000-1;
parameter 	SIM_VAL = 2047;

reg		[26:0]	timer_cnt;
reg 			timer_pulse_r;

assign timer_pulse = timer_pulse_r;

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		timer_cnt <= 'd0;
	else if (SIM_FLAG == 1'b0)
	begin
		if (timer_cnt == ONE_SEC)
			timer_cnt <= 'd0;
		else 
			timer_cnt <= timer_cnt + 1'b1;
	end
	else 
	begin
		if (timer_cnt == SIM_VAL)
			timer_cnt <= 'd0;
		else 
			timer_cnt <= timer_cnt + 1'b1;
	end
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		timer_pulse_r <= 1'b0;	
	else if (SIM_FLAG == 1'b1 && timer_cnt == SIM_VAL)
		timer_pulse_r <= 1'b1;
	else if (SIM_FLAG == 1'b0 && timer_cnt == ONE_SEC)
		timer_pulse_r <= 1'b1;
	else 
		timer_pulse_r <= 1'b0;
end

endmodule
