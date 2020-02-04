// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : rd_data_fifo_ctrl.v
// Create : 2020-02-03 09:31:38
// Revise : 2020-02-03 09:41:13
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module rd_data_fifo_ctrl(
	//user interface 
	input 	wire 			p1_rd_clk,
	input 	wire 			p1_rd_en,
	output 	wire 	[127:0]	p1_rd_data,
	output 	wire 	[6:0]	p1_rd_count,
	output 	wire 			p1_rd_empty,
	output 	wire 			p1_rd_full,
	//user connect 
	input 	wire 			p1_wr_clk,
	output 	wire 			rd_data_valid,
	output 	wire 	[127:0]	rd_data_128bit				
    );

rd_data_fifo inst_rd_data_fifo (
  .wr_clk(p1_wr_clk),                // input wire wr_clk
  .rd_clk(p1_rd_clk),                // input wire rd_clk
  .din(rd_data_128bit),                      // input wire [127 : 0] din
  .wr_en(rd_data_valid),                  // input wire wr_en
  .rd_en(p1_rd_en),                  // input wire rd_en
  .dout(p1_rd_data),                    // output wire [127 : 0] dout
  .full(p1_rd_full),                    // output wire full
  .empty(p1_rd_empty),                  // output wire empty
  .rd_data_count(p1_rd_count)  // output wire [6 : 0] rd_data_count
);
endmodule
