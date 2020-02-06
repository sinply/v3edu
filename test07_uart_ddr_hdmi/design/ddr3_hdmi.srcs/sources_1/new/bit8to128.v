// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : bit8to128.v
// Create : 2020-02-06 14:27:44
// Revise : 2020-02-06 22:05:30
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module bit8to128(
	input	wire			clk,
	input 	wire 			p2_clk,
	input 	wire 			rst,
	input 	wire 			po_flag,
	input 	wire 	[7:0]	po_data,
	output 	wire   			bit128_en,
	output  wire 	[127:0] bit128_data
    );

parameter 		BIT8_END_CNT = 1023,		//(128/16)*64*2-1 = 1024-1 
				BIT128_END_CNT = 63;		//64-1 = 63

reg  	[15:0]	wr_data;
reg 	[11:0]	wr_cnt;
reg 			wr_en;
reg				bit128_en_r;
reg 	[6:0]	bit128_cnt;
wire [7 : 0] rd_data_count;

assign bit128_en = bit128_en_r;

asfifo_wr16x1024_rd128x128 inst_uart_fifo (
  .wr_clk(clk),  // input wire wr_clk
  .rd_clk(p2_clk),  // input wire rd_clk
  .din(wr_data),        // input wire [15 : 0] din
  .wr_en(wr_en),    // input wire wr_en
  .rd_en(bit128_en),    // input wire rd_en
  .dout(bit128_data),      // output wire [127 : 0] dout
  .full(),      // output wire full
  .empty(),    // output wire empty
  .rd_data_count(rd_data_count)  // output wire [7 : 0] rd_data_count
);

//wr_data
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		wr_data <= 'd0;
	else if (po_flag == 1'b1)
		wr_data <= {wr_data[7:0], po_data};
end

//wr_cnt
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		wr_cnt <= 'd0;
	else if (po_flag == 1'b1 && wr_cnt == BIT8_END_CNT)
		wr_cnt <= 'd0;
	else if (po_flag == 1'b1)
		wr_cnt <= wr_cnt + 'd1;
end

//wr_en
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		wr_en <= 1'b0;	
	else if (wr_cnt[0] == 1'b1 && po_flag == 1'b1)
		wr_en <= 1'b1;
	else 
		wr_en <= 1'b0;
end

//bit128_en
always @(posedge p2_clk) 
begin
	if (rst == 1'b1) 
		bit128_en_r <= 1'b0;
	else if (rd_data_count > BIT128_END_CNT)
		bit128_en_r <= 1'b1;
	else if (bit128_en == 1'b1 && bit128_cnt == BIT128_END_CNT)
		bit128_en_r <= 1'b0;
end

//bit128_cnt
always @(posedge p2_clk) 
begin
	if (rst == 1'b1) 
		bit128_cnt <= 'd0;	
	else if (bit128_en == 1'b1 && bit128_cnt == BIT128_END_CNT)
		bit128_cnt <= 'd0;
	else if (bit128_en == 1'b1)
		bit128_cnt <= bit128_cnt + 'd1;	
end

wire [63:0] probe0;

assign probe0 = {
	p2_clk,
	po_flag,
	po_data,
	wr_cnt,
	wr_en,
	bit128_en,
	bit128_cnt,
	wr_data
};

ila_64bit inst_ila_uart_buffer (
	.clk(clk), // input wire clk


	.probe0(probe0) // input wire [63:0] probe0
);

endmodule
