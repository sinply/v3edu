// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : hdmi_buffer.v
// Create : 2020-02-05 10:54:32
// Revise : 2020-02-06 10:13:09
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module hdmi_buffer(
	//sys
	input 	wire 			p1_clk,		//ddr3
	input 	wire 			vga_clk,	//vga
	input 	wire 			rst,
	//user
	input 	wire 			p1_rd_en,	//ddr3
	input 	wire 	[127:0]	p1_rd_data,	//ddr3
	input 	wire 			rd_end,		//ddr3
	input 	wire 			vga_start,	//vga
	input 	wire 			vga_de,		//vga
	output  wire 			rd_start,	//ddr3
	output 	wire 	[15:0]	fifo_rd_data //vga
    );

parameter	IDLE	= 3'b001,
			JUDGE	= 3'b010,
			RD 		= 3'b100; 	

localparam	RD_END_CNT = 1500;		

wire 			full;
wire 			empty;
wire 			fifo_rd_en;
wire 	[12:0]	rd_data_count;

reg 	[2:0]	state;
reg 	 		rd_start_r;
reg 			rd_flag;

assign rd_start = rd_start_r;
assign fifo_rd_en = rd_flag & vga_de;

//state
always @(posedge p1_clk) 
begin
	if (rst == 1'b1) 
		state <= IDLE;
	else 
	begin
		case (state)
			IDLE:	state <= JUDGE;
			JUDGE:
				if (rd_data_count  < RD_END_CNT)		//fifo中的数据不足一行
					state <= RD;
			RD:
				if (rd_end == 1'b1)						//读取64突发长度数据完毕
					state <= JUDGE;
			default:
				state <= IDLE;
		endcase 
	end
end

//rd_start
always @(posedge p1_clk) 
begin
	if (rst == 1'b1) 
		rd_start_r <= 1'b0;	
	else if (state == JUDGE && rd_data_count  < RD_END_CNT)
		rd_start_r <= 1'b1;
	else
		rd_start_r <= 1'b0;
end

//rd_flag
always @(posedge vga_clk) 
begin
	if (rst == 1'b1) 
		rd_flag <= 1'b0;	
	else if (state == JUDGE && rd_data_count >= RD_END_CNT && vga_start == 1'b1)
		rd_flag <= 1'b1; 
	// else if (state == RD)
	// 	rd_flag <= 1'b0;
end

hdmi_buffer_fifo inst_hdmi_buffer_fifo (
  .wr_clk(p1_clk),                // input wire wr_clk
  .rd_clk(vga_clk),                // input wire rd_clk
  .din(p1_rd_data),                      // input wire [127 : 0] din
  .wr_en(p1_rd_en),                  // input wire wr_en
  .rd_en(fifo_rd_en),                  // input wire rd_en
  .dout(fifo_rd_data),                    // output wire [15 : 0] dout
  .full(full),                    // output wire full
  .empty(empty),                  // output wire empty
  .rd_data_count(rd_data_count)  // output wire [12 : 0] rd_data_count
);

wire [31:0] probe0;

assign probe0 = {
	vga_clk,
	rd_flag,
	p1_rd_en,
	rd_data_count,
	fifo_rd_en,
	rd_start,
	rd_end,
	state,
	rst,
	vga_start,
	vga_de,
	fifo_rd_data[4:0]
};

ila_hdmi_buffer inst_ila_hdmi_buffer (
	.clk(p1_clk), // input wire clk


	.probe0(probe0) // input wire [31:0] probe0
);
endmodule
