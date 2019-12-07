// -----------------------------------------------------------------------------
// Copyright (c) 2014-2019 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : a7_ddr3_rd_ctrl.v
// Create : 2019-10-31 16:23:01
// Revise : 2019-10-31 16:50:08
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module a7_ddr3_rd_ctrl(
	input 	wire 			sclk,
	input 	wire	        rst,
	//user read ports
	input 	wire 			rd_cmd_start,
	input 	wire 	[2:0]  	rd_cmd_instr,
	input 	wire 	[6:0]	rd_cmd_bl,
	input 	wire 	[27:0]	rd_cmd_addr,
	output 	wire 	[127:0]	rd_data_128bit,
	output  wire 			rd_data_valid,
	output 	wire 			rd_end,
	//ddr3 ipcore ports
	output 	wire 	[2:0]	app_cmd,
	output 	wire 			app_en,
	input 	wire 			app_rdy,
	output 	wire 	[27:0]	app_addr,
	input 	wire 	[127:0]	app_rd_data,
	input 	wire 			app_rd_data_valid
    );

reg 	[2:0]	cmd_instr;
reg 	[6:0]	cmd_bl;
reg 	[7:0]	cmd_cnt;
reg 			app_en_r;
reg 	[27:0]	app_addr_r;
reg 	[7:0]	data_cnt;
reg 			rd_end_r;

assign app_cmd = cmd_instr;
assign app_en = app_en_r;
assign app_addr = app_addr_r;
assign rd_data_128bit = app_rd_data;
assign rd_data_valid = app_rd_data_valid;
assign rd_end = rd_end_r;

always @ (posedge sclk) 
begin
	if (rst == 1'b1) 
	begin
		cmd_instr <= 'd0;
		cmd_bl <= 'd0;
	end
	else if (rd_cmd_start == 1'b1)
	begin
		cmd_instr <= rd_cmd_instr;
		cmd_bl <= rd_cmd_bl;
	end
end

always @ (posedge sclk) 
begin
	if (rst == 1'b1) 
		cmd_cnt <= 'd0;
	else if (app_en == 1'b1 && app_rdy == 1'b1 && cmd_cnt == (cmd_bl - 1))
		cmd_cnt <= 'd0;
	else if (app_en == 1'b1 && app_rdy == 1'b1)
		cmd_cnt <= cmd_cnt + 1'b1;
end

always @ (posedge sclk) 
begin
	if (rst == 1'b1) 
		app_en_r <= 1'b0;
	else if (app_en == 1'b1 && app_rdy == 1'b1 && cmd_cnt == (cmd_bl - 1))
		app_en_r <= 1'b0;
	else if (rd_cmd_start == 1'b1)
		app_en_r <= 1'b1;
end

always @ (posedge sclk) 
begin
	if (rst == 1'b1) 
		app_addr_r <= 'd0;
	else if (rd_cmd_start == 1'b1)
		app_addr_r <= rd_cmd_addr;
	else if (app_en == 1'b1 && app_rdy == 1'b1)
		app_addr_r <= app_addr + 'd8;
end

always @ (posedge sclk) 
begin
	if (rst == 1'b1) 
		data_cnt <= 'd0;
	else if (app_rd_data_valid == 1'b1 && data_cnt == (cmd_bl - 1))
		data_cnt <= 'd0;
	else if (app_rd_data_valid == 1'b1)
		data_cnt <= data_cnt + 1'b1;
end

always @ (posedge sclk) 
begin
	if (rst == 1'b1) 
		rd_end_r <= 1'b0;
	else if (app_rd_data_valid == 1'b1 && data_cnt == (cmd_bl - 1))
		rd_end_r <= 1'b1;
	else 
		rd_end_r <= 1'b0;
end

endmodule
