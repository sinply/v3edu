// -----------------------------------------------------------------------------
// Copyright (c) 2014-2019 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : A7_arbit.v
// Create : 2019-11-01 10:27:15
// Revise : 2019-11-01 10:47:29
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module A7_arbit(
	input 	wire 	clk,
	input 	wire 	rst,
	input	wire	wr_req,
	input 	wire 	rd_req,
	input 	wire 	wr_end,
	input 	wire 	rd_end,
	output 	wire 	wr_cmd_start,
	output 	wire 	rd_cmd_start
    );

localparam	IDLE	= 4'b0001,
			ARBIT 	= 4'b0010,
			WRITE	= 4'b0100,
			READ 	= 4'b1000;

reg 	[3:0]	state;
reg				wr_flag;
reg 			rd_flag;
reg 			wr_start;
reg 			rd_start;

assign wr_cmd_start = wr_start;
assign rd_cmd_start = rd_start;

//state
always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		state <= IDLE;
	else
	begin
		case (state)
			IDLE:
				state <= ARBIT;
			ARBIT:
				if (wr_req == 1'b1)
					state <= WRITE;
				else if (rd_req == 1'b1)
					state <= READ;
			WRITE:
				if (wr_end == 1'b1)
					state <= ARBIT;
			READ:
				if (rd_end == 1'b1)
					state <= ARBIT;
			default:
				state <= IDLE;
		endcase
	end
end

//wr_flag
always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		wr_flag <= 1'b0;
	else if (state == ARBIT && wr_req == 1'b1)
		wr_flag <= 1'b1;
	else if (state == WRITE && wr_end == 1'b1)
		wr_flag <= 1'b0;
end

//rd_flag
always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		rd_flag <= 1'b0;
	else if (state == ARBIT && rd_req == 1'b1 &&  wr_req == 1'b0)
		rd_flag <= 1'b1;
	else if (state == READ && rd_end == 1'b1)
		rd_flag <= 1'b0;
end

//wr_cmd_start
always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		wr_start <= 1'b0;
	else if (state == ARBIT && wr_req == 1'b1)
		wr_start <= 1'b1;
	else 
		wr_start <= 1'b0;
end

//rd_cmd_start
always @ (posedge clk) 
begin
	if (rst == 1'b1) 
		rd_start <= 1'b0;
	else if (state == ARBIT && rd_req == 1'b1 &&  wr_req == 1'b0)
		rd_start <= 1'b1;
	else 
		rd_start <= 1'b0;
end

endmodule
