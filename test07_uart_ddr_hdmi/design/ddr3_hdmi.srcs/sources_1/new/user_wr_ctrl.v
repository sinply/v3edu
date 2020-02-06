// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : user_wr_ctrl.v
// Create : 2020-02-04 10:26:04
// Revise : 2020-02-05 09:33:27
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module user_wr_ctrl(
	//input 
	input 	wire			clk,
	input 	wire			rst,
	input 	wire 			wr_en,
	input 	wire 	[127:0]	wr_data,
	input 	wire 			p2_wr_empty,
	//output 
	output 	wire 			p2_wr_en,
	output  wire 	[127:0]	p2_wr_data,
	output 	wire 	[15:0]	p2_wr_mask,
	output 	wire 			p2_cmd_en,
	output 	wire 	[6:0]	p2_cmd_bl,
	output 	wire 	[2:0]	p2_cmd_instr,
	output 	wire 	[27:0]	p2_cmd_addr,
	output	wire 			user_wr_end
    );

//1024*768@60Hz
parameter 		START_ADDR = 0,
				STOP_ADDR  = 785920, 	//1024*768-512 = 785920
				ADDR_ADDR  = 512;		//128*64/16 = 512

//write data 
reg 			wr_en_r;  			//wr_en延1拍
reg 			p2_wr_en_r;			//wr_en延2拍
reg 	[127:0]	p2_wr_data_r;
reg 	[6:0]	data_cnt;
//write cmd
reg 			p2_cmd_en_r;
reg 	[6:0]	p2_cmd_bl_r;
reg 	[27:0]	p2_cmd_addr_r = START_ADDR;
//user 
reg 			p2_wr_empty_r1;	
reg 			p2_wr_empty_r2;
reg 			p2_wr_empty_r3;
reg 			user_wr_end_r;	

//write data 
assign p2_wr_en = wr_en_r;
assign p2_wr_data = p2_wr_data_r;
assign p2_wr_mask = 'd0;
//write cmd
assign p2_cmd_en = p2_cmd_en_r;
assign p2_cmd_instr = 'd0;
assign p2_cmd_bl = p2_cmd_bl_r;
assign p2_cmd_addr = p2_cmd_addr_r;
//user 
assign user_wr_end = user_wr_end_r;

always @(posedge clk) 
begin
	wr_en_r <= wr_en;
end

always @(posedge clk) 
begin
	p2_wr_en_r <= p2_wr_en;
end

always @(posedge clk) 
begin
	p2_wr_data_r <= wr_data;
end

always @(posedge clk) 
begin
	p2_wr_empty_r1 <= p2_wr_empty;	
	p2_wr_empty_r2 <= p2_wr_empty_r1;	
	p2_wr_empty_r3 <= p2_wr_empty_r2;	
end

//data_cnt 
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		data_cnt <= 'd0;
	else if (wr_en == 1'b0 && wr_en_r == 1'b1)                	//下降沿检测
		data_cnt <= 'd0;
	else if (wr_en == 1'b1)
		data_cnt <= data_cnt + 1'b1;
end

//p2_cmd_en
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		p2_cmd_en_r <= 1'b0;
	else if (wr_en == 1'b0 && wr_en_r == 1'b1)             		//下降沿检测
		p2_cmd_en_r <= 1'b1;
	else 
		p2_cmd_en_r <= 1'b0;
end

//p2_cmd_bl
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		p2_cmd_bl_r <= 'd0;
	else if (wr_en == 1'b0 && wr_en_r == 1'b1)					//下降沿检测
		p2_cmd_bl_r <= data_cnt;
end

//p2_cmd_addr
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		p2_cmd_addr_r <= START_ADDR;
	else if (p2_wr_en == 1'b0 && p2_wr_en_r == 1'b1 && p2_cmd_addr_r == STOP_ADDR)
		p2_cmd_addr_r <= START_ADDR;
	else if (p2_wr_en == 1'b0 && p2_wr_en_r == 1'b1)			//下降沿检测
		p2_cmd_addr_r <= p2_cmd_addr_r + {p2_cmd_bl, 3'd0};
end

//user_wr_end 
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		user_wr_end_r <= 1'b0;
	else if (p2_wr_empty_r2 == 1'b1 && p2_wr_empty_r3 == 1'b0)		//上升沿检测
		user_wr_end_r <= 1'b1;
	else 	
		user_wr_end_r <= 1'b0;
end

endmodule

