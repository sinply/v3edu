// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : rd_cmd_fifo_ctrl.v
// Create : 2020-02-03 09:25:51
// Revise : 2020-02-03 09:30:08
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module rd_cmd_fifo_ctrl(
	//user interface 
	input 	wire 			p1_cmd_clk,
	input 	wire 			p1_cmd_en,
	input 	wire 	[2:0]	p1_cmd_instr,
	input 	wire 	[27:0]	p1_cmd_addr,
	input 	wire 	[6:0]	p1_cmd_bl,
	output 	wire 			p1_cmd_full,
	output	wire 			p1_cmd_empty,
	//user connect 
	input 	wire 			p1_cmd_rd_clk,
	input 	wire 			p1_cmd_rd_en,
	output  wire  	[6:0]	rd_cmd_bl,
	output 	wire 	[27:0]	rd_cmd_addr,
	output 	wire 	[2:0]	rd_cmd_instr
    );

wire 	[37:0]	fifo_wr_data;
wire 	[37:0]	fifo_rd_data;

assign fifo_wr_data = {p1_cmd_bl, p1_cmd_addr, p1_cmd_instr};
assign rd_cmd_bl = fifo_rd_data[37:31];
assign rd_cmd_addr = fifo_rd_data[30:3];
assign rd_cmd_instr = fifo_rd_data[2:0];

cmd_fifo inst_rd_cmd_fifo (
  .wr_clk(p1_cmd_clk),  // input wire wr_clk
  .rd_clk(p1_cmd_rd_clk),  // input wire rd_clk
  .din(fifo_wr_data),        // input wire [37 : 0] din
  .wr_en(p1_cmd_en),    // input wire wr_en
  .rd_en(p1_cmd_rd_en),    // input wire rd_en
  .dout(fifo_rd_data),      // output wire [37 : 0] dout
  .full(p1_cmd_full),      // output wire full
  .empty(p1_cmd_empty)    // output wire empty
);

endmodule

