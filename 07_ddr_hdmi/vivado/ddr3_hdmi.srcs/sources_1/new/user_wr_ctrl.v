// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : user_wr_ctrl.v
// Create : 2020-02-04 15:24:36
// Revise : 2020-02-04 16:31:29
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module user_wr_ctrl(
	input 	wire 			clk,
	input 	wire 			rst,
	input 	wire 			wr_en,
	input 	wire 	[127:0]	wr_data,
	output 	wire 			p2_wr_en,
	output 	wire 	[127:0]	p2_wr_data,
	output 	wire 	[15:0]	p2_wr_mask,
	output 	wire 			p2_cmd_en,
	output 	wire 	[6:0]	p2_cmd_bl,
	output 	wire 	[2:0]	p2_cmd_instr,
	output 	wire 	[27:0]	p2_cmd_addr,
	input 	wire 			p2_wr_empty,
	output 	wire	 		user_wr_end
    );

//1024*768
//16bit / pixel 
//1024*768 - 512 = 785920
parameter BURST_LEN = 64;
parameter START_ADDR = 0;
parameter STOP_ADDR = 785920;
parameter ADD_ADDR = 64*128/16; //=512

reg 			wr_en_r;
reg		[127:0]	wr_data_r;
reg 			wr_cmd_en_r;
reg 	[27:0]	wr_cmd_addr_r = START_ADDR;
reg 			wr_end_r;
reg 			wr_empty_r, wr_empty_rr, wr_empty_rrr;

assign p2_wr_en = wr_en_r;
assign p2_wr_data = wr_data_r;
assign p2_cmd_en = wr_cmd_en_r;
assign p2_wr_mask = 'd0;
assign p2_cmd_bl = BURST_LEN;
assign p2_cmd_instr = 'd0;
assign p2_cmd_addr = wr_cmd_addr_r;
assign user_wr_end = wr_end_r;

always @(posedge clk) 
begin
	if (rst == 1'b1) 
	begin
		wr_en_r <= 1'b0;
		wr_data_r <= 'd0;
	end 
	else 
	begin
		wr_en_r <= wr_en;
		wr_data_r <= wr_data;	
	end	
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		wr_cmd_en_r <= 1'b0;
	else if (wr_en == 1'b0 && wr_en_r == 1'b1)
		wr_cmd_en_r <= 1'b1;
	else 
		wr_cmd_en_r <= 1'b0;	
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		wr_cmd_addr_r <= START_ADDR;
	else if (wr_cmd_addr_r == STOP_ADDR && wr_cmd_en_r == 1'b1)
		wr_cmd_addr_r <= START_ADDR;	
	else if (wr_cmd_en_r == 1'b1)
		wr_cmd_addr_r <= wr_cmd_addr_r + ADD_ADDR;
end

//亚稳态，打俩拍消除
always @(posedge clk) 
begin
	wr_empty_r <= p2_wr_empty;	
	wr_empty_rr <= wr_empty_r;
	wr_empty_rrr <= wr_empty_rr;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		wr_end_r <= 1'b0;	
	else if (wr_empty_rr == 1'b1 && wr_empty_rrr == 1'b0)
		wr_end_r <= 1'b1;
	else 	
		wr_end_r <= 1'b0;
end

endmodule
