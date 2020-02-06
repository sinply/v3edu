// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : user_rd_ctrl.v
// Create : 2020-02-04 11:07:50
// Revise : 2020-02-05 09:35:10
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module user_rd_ctrl(
	//input 
	input	wire 			clk,
	input 	wire	 		rst,
	input 	wire 			rd_start,
	input 	wire	[6:0] 	p1_rd_count,
	//output 
	output 	wire 			p1_rd_en,
	output	wire 			p1_cmd_en,
	output 	wire 	[6:0]	p1_cmd_bl,
	output 	wire 	[2:0]	p1_cmd_instr,
	output  wire 	[27:0]	p1_cmd_addr,
	output 	wire 			user_rd_end		
    );

parameter 		BL = 64;
//1024*768@60Hz
parameter 		START_ADDR = 0,
				STOP_ADDR  = 785920, 	//1024*768-512 = 785920
				ADDR_ADDR  = 512;		//128*64/16 = 512

//rd cmd
reg 			p1_cmd_en_r;
reg		[27:0]	p1_cmd_addr_r = START_ADDR; 
//rd data
reg 			p1_rd_en_r;
reg 	[6:0]	data_cnt;
reg 			p1_rd_en_r1;
reg 			user_rd_end_r;

//rd cmd
assign p1_cmd_instr = 'd1;
assign p1_cmd_bl = BL;
assign p1_cmd_en = p1_cmd_en_r;
assign p1_cmd_addr = p1_cmd_addr_r;
//rd data
assign p1_rd_en = p1_rd_en_r;
assign user_rd_end = user_rd_end_r;

//p1_cmd_en
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		p1_cmd_en_r <= 1'b0;	
	else if (rd_start == 1'b1)
		p1_cmd_en_r <= 1'b1;
	else 
		p1_cmd_en_r <= 1'b0;
end

//p1_cmd_addr
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		p1_cmd_addr_r <= START_ADDR;
	else if (p1_cmd_en == 1'b1 && p1_cmd_addr == STOP_ADDR)
		p1_cmd_addr_r <= START_ADDR;
	else if (p1_cmd_en == 1'b1)
		p1_cmd_addr_r <= p1_cmd_addr_r + {p1_cmd_bl, 3'd0};	
end
//data_cnt
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		data_cnt <= 'd0;	
	else if (user_rd_end == 1'b1)
		data_cnt <= 'd0;
	else if (p1_rd_en == 1'b1)
		data_cnt <= data_cnt + 'd1;
end
//p1_rd_en
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		p1_rd_en_r <= 1'b0;	
	else if (data_cnt == (BL - 'd1))
		p1_rd_en_r <= 1'b0;
	else if (p1_rd_count == BL)
		p1_rd_en_r <= 1'b1;
end

always @(posedge clk) 
begin
	p1_rd_en_r1 <= p1_rd_en;	
end

//user_rd_end
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		user_rd_end_r <= 1'b0;	
	else if (p1_rd_en == 1'b0 && p1_rd_en_r1 == 1'b1)
		user_rd_end_r <= 1'b1;
	else 
		user_rd_end_r <= 1'b0;
end

endmodule
