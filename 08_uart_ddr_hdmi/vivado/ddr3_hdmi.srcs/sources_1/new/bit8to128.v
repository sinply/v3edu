// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : bit8to128.v
// Create : 2020-02-06 16:38:59
// Revise : 2020-02-06 19:22:19
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------

module bit8to128(
	input 	wire 			clk,
	input 	wire 			rst,
	input 	wire 			rx_flag,
	input 	wire 	[7:0]	rx_data,
	output 	wire 			wr_en,
	output 	wire 	[127:0]	wr_data
	);

parameter 	BURST_LEN 	= 64;

reg 	[15:0]	shift_reg;
reg 			rx_cnt = 0;
reg 			wr_fifo_en;
wire 	[15:0]	wr_fifo_data;
wire 	[7:0]	rd_data_count;
reg 			rd_en;
reg 	[7:0]	rd_cnt;

assign wr_fifo_data = shift_reg;
assign wr_en = rd_en;

always @(posedge clk) 
begin
	if (rx_flag == 1'b1)
		shift_reg <= {shift_reg[7:0], rx_data};
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rx_cnt <= 'd0;	
	else if (rx_flag == 1'b1)
		rx_cnt <= rx_cnt + 1'b1;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		wr_fifo_en <= 1'b0;	
	else if (rx_cnt == 1'b1 && rx_flag == 1'b1)
		wr_fifo_en <= 1'b1;
	else 
		wr_fifo_en <= 1'b0;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rd_en <= 1'b0;	
	else if (rd_data_count >= BURST_LEN)
		rd_en <= 1'b1;
	else if (rd_cnt == BURST_LEN - 1)
		rd_en <= 1'b0;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rd_cnt <= 'd0;	
	else if (rd_cnt == BURST_LEN - 1 && rd_en == 1'b1)
		rd_cnt <= 'd0;
	else if (rd_en == 1'b1)
		rd_cnt <= rd_cnt + 'd1;		
end

afifo_wr16x1024_rd128x128 inst_uart_buffer (
  .clk(clk),                      // input wire clk
  .din(wr_fifo_data),                      // input wire [15 : 0] din
  .wr_en(wr_fifo_en),                  // input wire wr_en
  .rd_en(wr_en),                  // input wire rd_en
  .dout(wr_data),                    // output wire [127 : 0] dout
  .full(),                    // output wire full
  .empty(),                  // output wire empty
  .rd_data_count(rd_data_count)  // output wire [7 : 0] rd_data_count
);

wire [31:0] probe0;
assign probe0 = {
	rd_en,
	rd_cnt,
	rd_data_count,
	rx_cnt,
	wr_fifo_en,
	rx_flag
};

ila_0 inst_ila_bit8to128 (
  .clk(clk), // input wire clk


  .probe0(probe0) // input wire [31:0] probe0
);
endmodule 