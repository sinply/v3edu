// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : wr_data_fifo_ctrl.v
// Create : 2020-02-02 11:46:10
// Revise : 2020-02-03 10:07:39
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module wr_data_fifo_ctrl(
	//user interface 
	input 	wire 			p2_wr_clk,
	input 	wire 			p2_wr_en,
	input 	wire 	[127:0]	p2_wr_data,
	input 	wire 	[15:0]	p2_wr_mask,
	output 	wire 	[6:0]	p2_wr_count,		//写数据的计数量
	output 	wire 			p2_wr_empty,
	output 	wire 			p2_wr_full,
	//user connect
	input 	wire    		p2_rd_clk,
	output	wire 	[15:0]	wr_cmd_mask,
	output 	wire 	[127:0]	data_128bit,
	input 	wire 			data_req
    );

wire 	[143:0]	fifo_wr_data;
wire 	[143:0] fifo_rd_data;

assign fifo_wr_data = {p2_wr_mask, p2_wr_data};
assign wr_cmd_mask = fifo_rd_data[143:128];
assign data_128bit = fifo_rd_data[127:0];

wr_data_fifo inst_wr_data_fifo (
  .wr_clk(p2_wr_clk),                // input wire wr_clk
  .rd_clk(p2_rd_clk),                // input wire rd_clk
  .din(fifo_wr_data),                      // input wire [143 : 0] din
  .wr_en(p2_wr_en),                  // input wire wr_en
  .rd_en(data_req),                  // input wire rd_en
  .dout(fifo_rd_data),                    // output wire [143 : 0] dout
  .full(p2_wr_full),                    // output wire full
  .empty(p2_wr_empty),                  // output wire empty
  .wr_data_count(p2_wr_count)  // output wire [6 : 0] wr_data_count
);


endmodule
