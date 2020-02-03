// -----------------------------------------------------------------------------
// Copyright (c) 2014-2019 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : arbit.v
// Create : 2019-11-01 19:27:03
// Revise : 2019-11-02 08:56:46
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module arbit(
	input	wire	sclk,
	input 	wire 	rst,
	input 	wire 	rd_req,
	input 	wire 	wr_req,
	input 	wire 	rd_end,
	input 	wire 	wr_end,
	output 	wire 	rd_cmd_start,
	output 	wire 	wr_cmd_start
    );

reg 	[3:0]	state;
reg 			wr_flag;
reg 			rd_flag;
reg 			wr_start;
reg	 			rd_start;

localparam	IDLE 	= 4'b0001,
			ARBIT 	= 4'b0010,
			WR 		= 4'b0100,
			RD 		= 4'b1000;

assign wr_cmd_start = wr_start;
assign rd_cmd_start = rd_start;

always @ (posedge sclk) 
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
					state <= WR;
				else if (rd_req == 1'b1)
					state <= RD;
			WR:
				if (wr_end == 1'b1)
					state <= ARBIT;
			RD:
				if (rd_end == 1'b1)
					state <= ARBIT;
			default:
				state <= IDLE;
		endcase
	end
end

always @ (posedge sclk) 
begin
	if (rst == 1'b1) 
		wr_flag <= 1'b0;
	else if (state == WR && wr_flag == 1'b1)
		wr_flag <= 1'b0;	
	else if (wr_req == 1'b1)
		wr_flag <= 1'b1;
end

always @ (posedge sclk) 
begin
	if (rst == 1'b1) 
		wr_start <= 1'b0;
	else if (state == WR && wr_flag == 1'b1)
		wr_start <= 1'b1;
	else 
		wr_start <= 1'b0;
end

always @ (posedge sclk) 
begin
	if (rst == 1'b1) 
		rd_flag <= 1'b0;
	else if (state == RD && rd_flag == 1'b1)
		rd_flag <= 1'b0;
	else if (rd_req == 1'b1)
		rd_flag <= 1'b1;
end

always @ (posedge sclk) 
begin
	if (rst == 1'b1) 
		rd_start <= 1'b0;
	else if (state == RD && rd_flag == 1'b1)
		rd_start <= 1'b1;
	else 
		rd_start <= 1'b0;
end

endmodule
