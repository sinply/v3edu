// -----------------------------------------------------------------------------
// Copyright (c) 2014-2019 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : A7_rd_ctrl.v
// Create : 2019-10-31 14:24:57
// Revise : 2019-10-31 14:58:22
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module A7_rd_ctrl(
	//system interface 
	input 	wire 			clk,
	input 	wire 			rst,
	//ddr3 read interface
	input	wire 			rd_cmd_start,
	input 	wire 	[6:0]	rd_cmd_bl,
	input 	wire 	[2:0]	rd_cmd_instr,
	input 	wire 	[27:0]	rd_cmd_addr,
	output 	wire 			rd_data_valid,
	output 	wire 	[127:0]	rd_data_128bit,
	output 	wire 			rd_end,
	//ddr3 ctrl interface
	output	wire			app_en,
	output  wire 	[2:0]	app_cmd,
	output 	wire 	[27:0]	app_addr,
	input 	wire 			app_rdy,
	input 	wire 	[127:0]	app_rd_data,
	input 	wire 			app_rd_data_valid
    );

reg 	[6:0]	cmd_bl;
reg 	[2:0]	cmd_instr;
reg 	[27:0]	cmd_addr;
reg 			app_en_r;
reg 	[7:0]	addr_cnt;
reg 	[7:0]	data_cnt;
reg 			rd_end_r;

assign app_en = app_en_r;
assign app_cmd = cmd_instr;
assign app_addr = cmd_addr;
assign rd_data_128bit = app_rd_data;
assign rd_data_valid = app_rd_data_valid;
assign rd_end = rd_end_r;

always @ (posedge clk) 
begin
	if (rst == 1'b1) 
	begin
		cmd_bl <= 'd0;
		cmd_instr <= 'd0;		
	end	
	else if (rd_cmd_start == 1'b1)
	begin
		cmd_bl <= rd_cmd_bl;
		cmd_instr <= rd_cmd_instr;
	end
end

//addr 
always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		app_en_r <= 1'b0;
	else if (addr_cnt == (cmd_bl - 'd1) && app_en == 1'b1 && app_rdy == 1'b1)
		app_en_r <= 1'b0;
	else if (rd_cmd_start == 1'b1)
		app_en_r <= 1'b1;
end

//addr_cnt
always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		addr_cnt <= 'd0;
	else if (app_en == 1'b1 && app_rdy == 1'b1 && addr_cnt == (cmd_bl - 'd1))
		addr_cnt <= 'd0;
	else if (app_en == 1'b1 && app_rdy == 1'b1)
		addr_cnt <= addr_cnt + 1'b1;
end

always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		cmd_addr <= 'd0;
	else if (app_en == 1'b1 && app_rdy == 1'b1)
		cmd_addr <= cmd_addr + 'd8;
	else if (rd_cmd_start == 1'b1)
		cmd_addr <= rd_cmd_addr;
end

//data
always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		data_cnt <= 'd0;
	else if (app_rd_data_valid == 1'b1 && data_cnt == (cmd_bl - 'd1))
		data_cnt <= 'd0;
	else if (app_rd_data_valid == 1'b1)
		data_cnt <= data_cnt + 1'b1;
end

always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		rd_end_r <= 1'b0;
	else if (app_rd_data_valid == 1'b1 && data_cnt == (cmd_bl - 'd1))
		rd_end_r <= 1'b1;
	else 
		rd_end_r <= 1'b0;
end

endmodule
