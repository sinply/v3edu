// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : rx_buffer.v
// Create : 2020-02-09 10:20:36
// Revise : 2020-02-09 10:26:06
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module rx_buffer(
	input 	wire			wr_clk,
	input 	wire 			rd_clk,
	input 	wire			wr_en,
	input 	wire 	[7:0]	wr_data,
	input 	wire 			rd_en,
	output 	wire 	[7:0]	rd_data
    );

asfifo_wr8x8192_rd8x8192 inst_rx_buffer_fifo (
  .wr_clk(wr_clk),  // input wire wr_clk
  .rd_clk(rd_clk),  // input wire rd_clk
  .din(wr_data),        // input wire [7 : 0] din
  .wr_en(wr_en),    // input wire wr_en
  .rd_en(rd_en),    // input wire rd_en
  .dout(rd_data),      // output wire [7 : 0] dout
  .full(),      // output wire full
  .empty()    // output wire empty
);
endmodule
