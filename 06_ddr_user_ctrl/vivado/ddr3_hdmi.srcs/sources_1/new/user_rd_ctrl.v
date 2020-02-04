// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : user_rd_ctrl.v
// Create : 2020-02-04 15:55:23
// Revise : 2020-02-04 16:18:21
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module user_rd_ctrl(
	input 	wire			clk,
	input 	wire 			rst, 
	input 	wire 			rd_start,
	output  wire 			p1_rd_en, 
	output 	wire 			p1_cmd_en,
	output 	wire	[2:0]	p1_cmd_instr,
	output 	wire 	[6:0]	p1_cmd_bl,
	output 	wire 	[27:0]	p1_cmd_addr,	
	input 	wire 	[6:0]	p1_rd_count,	
	output 	wire 			user_rd_end
    );

//1024*768
//16bit / pixel 
//1024*768 - 512 = 785920
parameter BURST_LEN = 64;
parameter START_ADDR = 0;
parameter STOP_ADDR = 785920;
parameter ADD_ADDR = 64*128/16; //=512

reg 			cmd_en_r;
reg 	[127:0] rd_cmd_addr_r = START_ADDR;
reg 			rd_en_r;
reg 	[6:0]	data_cnt;
reg 			rd_end_r;

assign p1_cmd_bl = BURST_LEN;
assign p1_cmd_instr = 'd1;
assign p1_cmd_en = cmd_en_r;
assign p1_cmd_addr = rd_cmd_addr_r;
assign p1_rd_en = rd_en_r;
assign user_rd_end= rd_end_r;

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		cmd_en_r <= 1'b0;	
	else if (rd_start == 1'b1)
		cmd_en_r <= 1'b1;
	else 	
		cmd_en_r <= 1'b0;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rd_cmd_addr_r <= START_ADDR;	
	else if (rd_cmd_addr_r == STOP_ADDR && cmd_en_r == 1'b1)
		rd_cmd_addr_r <= START_ADDR;
	else if (cmd_en_r == 1'b1)
		rd_cmd_addr_r <= rd_cmd_addr_r + ADD_ADDR;	
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rd_en_r <= 1'b0;
	else if (data_cnt == (BURST_LEN - 1))
		rd_en_r <= 1'b0;	
	else if (p1_rd_count == BURST_LEN)
		rd_en_r <= 1'b1;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		data_cnt <= 'd0;
	else if (rd_en_r == 1'b1 && data_cnt == (BURST_LEN - 1))
		data_cnt <= 'd0;
	else if (rd_en_r == 1'b1)
		data_cnt <= data_cnt + 1'b1;	
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rd_end_r <= 1'b0;	
	else if (data_cnt == (BURST_LEN - 1))
		rd_end_r <= 1'b1;
	else 
		rd_end_r <= 1'b0;	
end

endmodule
