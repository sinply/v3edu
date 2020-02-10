// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : rx_filter.v
// Create : 2020-02-09 10:33:57
// Revise : 2020-02-10 09:55:23
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module rx_filter(
	input 	wire 				clk,
	input	wire 				rst,
	input 	wire 				rx_en,
	input 	wire	[7:0]		rx_data,
	output 	wire 	[15:0]		pkg_status,
	output  wire 				pkg_end
    );

localparam	HEAD_END_CNT 	= 7,		//frame end data count 
			ORIGIN_END_CNT 	= 43+1,		//origin port
			DEST_END_CNT	= 45+1,		//destination port
			UDP_END_CNT 	= 31,		//udp protocol
			DATA_START_CNT 	= 49;

localparam  ORIGIN_PORT		= 1234,
			DEST_PORT 		= 123,
			UDP_CODE 		= 8'h11;

reg 			rx_en_new;
reg 	[13:0]	rx_en_cnt;	
wire 			crc32_error;
wire 			crc32_cal_end;
reg 	[15:0]	rx_data_r;
reg 			origin_ok, dest_ok, udp_ok;
reg 			rx_en_r;
reg 			pkg_valid;
reg 			pkg_end_r;
reg	 	[13:0]	status_r;

assign pkg_end = pkg_end_r;
assign pkg_status[14] = pkg_valid;
assign pkg_status[15] = crc32_cal_end & (~crc32_error);
assign pkg_status[13:0] = status_r;

//crc check
always @(posedge clk or negedge rx_en) 
begin
	if (rx_en == 1'b0) 
		rx_en_new <= 1'b0;	
	else if (rx_en == 1'b1 && rx_en_cnt == HEAD_END_CNT)
		rx_en_new <= 1'b1;
end

//rx_en_cnt
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rx_en_cnt <= 'd0;	
	else if (rx_en == 1'b1)
		rx_en_cnt <= rx_en_cnt + 'd1;
	else 
		rx_en_cnt <= 'd0;
end

crc32_d8_rec_02 inst_crc32_d8_rec_02
	(
		.resetb        (~rst),
		.sclk          (clk),
		.dsin          (rx_en_new),
		.din           (rx_data),
		.crc32_cal_end (crc32_cal_end),
		.crc32_error   (crc32_error)
	);

//rx_data_r
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rx_data_r <= 'd0;
	else if (rx_en == 1'b1)
		rx_data_r <= {rx_data_r[7:0], rx_data};
end

//origin_ok
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		origin_ok <= 1'b0;	
	else if (rx_en == 1'b0)
		origin_ok <= 1'b0;
	else if (rx_en_cnt == ORIGIN_END_CNT && rx_data_r == ORIGIN_PORT && rx_en == 1'b1)
		origin_ok <= 1'b1;
end

//dest_ok
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		dest_ok <= 1'b0;
	else if (rx_en == 1'b0)
		dest_ok <= 1'b0;
	else if (rx_en_cnt == DEST_END_CNT && rx_data_r == DEST_PORT && rx_en == 1'b1)
		dest_ok <= 1'b1;
end

//udp_ok
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		udp_ok <= 1'b0;
	else if (rx_en == 1'b0)
		udp_ok <= 1'b0;
	else if (rx_en_cnt == UDP_END_CNT && rx_data == UDP_CODE && rx_en == 1'b1)
		udp_ok <= 1'b1;
end 

always @(posedge clk) 
begin
	rx_en_r <= rx_en;	
end

//pkg_end
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		pkg_end_r <= 1'b0;
	else if (rx_en == 1'b0 && rx_en_r == 1'b1)
		pkg_end_r <= 1'b1;
	else 
		pkg_end_r <= 1'b0;
end

//pkg_valid
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		pkg_valid <= 1'b0;	
	else if (rx_en == 1'b0 && rx_en_r == 1'b1 && origin_ok == 1'b1 && dest_ok == 1'b1 && udp_ok == 1'b1)
		pkg_valid <= 1'b1;
	else 
		pkg_valid <= 1'b0;	
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		status_r <= 'd0;	
	else if (rx_en == 1'b0 && rx_en_r == 1'b1)
		status_r <= rx_en_cnt;
	else 
		status_r <= 'd0;
end

wire 	[31:0]	probe0;
assign probe0 = {
	rx_en, 
	rx_data,
	udp_ok,
	origin_ok,
	dest_ok,
	pkg_end,
	pkg_status
};

ila_0 inst_ila_rx_filter (
	.clk(clk), // input wire clk


	.probe0(probe0) // input wire [31:0] probe0
);

endmodule
