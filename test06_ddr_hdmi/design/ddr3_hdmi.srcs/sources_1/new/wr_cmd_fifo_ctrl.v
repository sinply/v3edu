// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : wr_cmd_fifo_ctrl.v
// Create : 2020-02-03 09:03:28
// Revise : 2020-02-03 09:24:06
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module wr_cmd_fifo_ctrl(
	//user interface 
	input 	wire 			p2_cmd_clk,
	input 	wire 			p2_cmd_en,
	input 	wire 	[2:0]	p2_cmd_instr,
	input 	wire 	[27:0]	p2_cmd_addr,
	input 	wire 	[6:0]	p2_cmd_bl,
	output 	wire 			p2_cmd_full,
	output	wire 			p2_cmd_empty,
	//user connect 
	input 	wire 			p2_cmd_rd_clk,
	input 	wire 			p2_cmd_rd_en,
	output  wire  	[6:0]	wr_cmd_bl,
	output 	wire 	[27:0]	wr_cmd_addr,
	output 	wire 	[2:0]	wr_cmd_instr
    );

wire 	[37:0]	fifo_wr_data;
wire 	[37:0]	fifo_rd_data;

assign fifo_wr_data = {p2_cmd_bl, p2_cmd_addr, p2_cmd_instr};
assign wr_cmd_bl = fifo_rd_data[37:31];
assign wr_cmd_addr = fifo_rd_data[30:3];
assign wr_cmd_instr = fifo_rd_data[2:0];

cmd_fifo inst_wr_cmd_fifo (
  .wr_clk(p2_cmd_clk),  // input wire wr_clk
  .rd_clk(p2_cmd_rd_clk),  // input wire rd_clk
  .din(fifo_wr_data),        // input wire [37 : 0] din
  .wr_en(p2_cmd_en),    // input wire wr_en
  .rd_en(p2_cmd_rd_en),    // input wire rd_en
  .dout(fifo_rd_data),      // output wire [37 : 0] dout
  .full(p2_cmd_full),      // output wire full
  .empty(p2_cmd_empty)    // output wire empty
);

endmodule
