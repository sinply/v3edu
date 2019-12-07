// -----------------------------------------------------------------------------
// Copyright (c) 2014-2019 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : A7_wr_ctrl.v
// Create : 2019-10-30 15:35:39
// Revise : 2019-10-31 00:21:23
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module A7_wr_ctrl(
	//app interface 
	output 	[27:0]    	app_addr,
	output 	[2:0]       app_cmd,
	output             	app_en,
	output 	[127:0]     app_wdf_data,
	output 	[15:0]      app_wdf_mask,
	output             	app_wdf_wren,
	input            	app_rdy,
	input            	app_wdf_rdy,
	input             	clk,
	input             	rst,
	//user interface 
	input 	wire 	[127:0] 	data_128bit,
	input 	wire 				wr_cmd_start,
	input 	wire 	[6:0]		wr_cmd_bl,
	input 	wire 	[27:0]		wr_cmd_addr,
	input 	wire 	[2:0]		wr_cmd_instr,
	input 	wire	[15:0]		wr_cmd_mask,
	output	wire 				data_req,
	output 	wire 				wr_end
    );

reg [6:0] 	data_cnt;
reg [6:0]	addr_cnt;
reg [127:0]	wr_addr;
reg 		data_wr_en;
reg 		addr_wr_en;
reg 		addr_wr_end;
reg	[15:0]	cmd_mask;
reg [2:0]	cmd_instr;
reg [6:0]	cmd_bl;

assign app_wdf_data = data_128bit;
assign app_wdf_wren = data_wr_en;
assign app_en = addr_wr_en;
assign app_addr = wr_addr;
assign data_req = app_wdf_rdy & app_wdf_wren;
//
assign app_wdf_mask = cmd_mask;
assign app_cmd = cmd_instr;
assign wr_end = addr_wr_end;

//data
always @ (posedge clk) 
begin	
	if (rst == 1'b1) 
	begin
		cmd_mask <= 'd0;
		cmd_instr <= 'd0;
		cmd_instr <= 'd0;
	end
	else if (wr_cmd_start == 1'b1)
	begin
		cmd_mask <= wr_cmd_mask;
		cmd_instr <= wr_cmd_instr;
		cmd_bl <= wr_cmd_bl;
	end
end

always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		data_wr_en <= 1'b0;
	else if (wr_cmd_start == 1'b1)
		data_wr_en <= 1'b1;
	else if (app_wdf_wren == 1'b1 && app_wdf_rdy == 1'b1 && data_cnt == cmd_bl - 'd1)
		data_wr_en <= 1'b0;
end

always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		data_cnt <= 'd0;	
	else if (app_wdf_wren == 1'b1 && app_wdf_rdy == 1'b1 && data_cnt == cmd_bl - 'd1)
		data_cnt <= 'd0;
	else if (app_wdf_wren == 1'b1 && app_wdf_rdy == 1'b1)
		data_cnt <= data_cnt + 1'b1;
end

//addr 
always @ (posedge clk) 
begin
	if (rst == 1'b1)
		addr_wr_en <= 1'b0;
	else if (app_rdy == 1'b1 && app_en == 1'b1 && addr_cnt == cmd_bl - 'd1)
		addr_wr_en <= 1'b0;
	else if (data_req == 1'b1)
		addr_wr_en <= 1'b1;
end

always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		wr_addr <= 'd0;	
	else if (wr_cmd_start == 1'b1)
		wr_addr <= wr_cmd_addr;
	else if (app_rdy == 1'b1 && app_en == 1'b1)
		wr_addr <= wr_addr + 'd8;
end

always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		addr_cnt <= 'd0;	
	else if (app_rdy == 1'b1 && app_en == 1'b1 && addr_cnt == cmd_bl - 'd1)
		addr_cnt <= 'd0; 
	else if (app_rdy == 1'b1 && app_en == 1'b1)
		addr_cnt <= addr_cnt + 1'b1; 
end

always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		addr_wr_end <= 1'b0;	
	else if (app_rdy == 1'b1 && app_en == 1'b1 && addr_cnt == cmd_bl - 'd1)
		addr_wr_end <= 1'b1;
	else 
		addr_wr_end <= 1'b0;
end

endmodule
