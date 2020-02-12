// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : add_check_sum.v
// Create : 2020-02-11 19:25:19
// Revise : 2020-02-11 21:46:34
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module add_check_sum(
	input 	wire 			clk,
	input 	wire 			rst,
	input 	wire 			tx_en,
	input 	wire 	[7:0]	tx_data,
	output 	reg  			checksum_en,
	output 	reg 	[7:0]	checksum_data
    );

parameter 	TX_END_CNT 		= 113,
			IP_START_CNT 	= 21,
			IP_END_CNT 		= 41,
			UDP_START_CNT 	= 41,
			UDP_END_CNT 	= 113,
			RD_END_CNT 		= 113;

parameter	IP_CHECK_START 	= 33,
			IP_CHECK_END	= 34,
			UDP_CHECK_START = 49,
			UDP_CHECK_END 	= 50;

parameter 	IP_VIRT_DATA 	= 16'hC102;

reg 	[7:0]	tx_cnt;
//ip checksum
reg 			shift_ip_en;
reg 	[15:0]	shift_ip_data;
reg 			shift_ip_en_r;
reg				shift_ip_flag;
reg		[31:0]	ip_sum;
reg 			shift_ip_en_rr;
reg 	[15:0]	ip_checksum;	
//udp checksum	
reg 			shift_udp_en;
reg 	[15:0]	shift_udp_data;
reg 			shift_udp_en_r;
reg				shift_udp_flag;
reg		[31:0]	udp_sum;
reg 			shift_udp_en_rr;
reg 	[15:0]	udp_checksum;
wire 			tx_end_flag;
//add checksum
reg 			rd_en;
reg 	[7:0]	rd_addr;
wire  	[7:0]	rd_data;
reg 			rd_en_r;

assign tx_end_flag = (~shift_udp_en_r) & shift_udp_en_rr;

//tx_cnt
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		tx_cnt <= 'd0;
	else if (tx_en == 1'b1 && tx_cnt == TX_END_CNT)
		tx_cnt <= 'd0;
	else if (tx_en == 1'b1)
		tx_cnt <= tx_cnt + 1'b1;
end

//-----------------------------------------------
//ip checksum 

//shift_ip_en
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		shift_ip_en <= 1'b0;	
	else if (tx_en == 1'b1 && tx_cnt == IP_END_CNT)	
		shift_ip_en <= 1'b0;
	else if (tx_en == 1'b1 && tx_cnt == IP_START_CNT)
		shift_ip_en <= 1'b1;
end

//shift_ip_data
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		shift_ip_data <= 'd0;	
	else if (shift_ip_en == 1'b1)
		shift_ip_data <= {shift_ip_data[7:0], tx_data};
	else
		shift_ip_data <= 'd0;
end

//shift_ip_en_r
always @(posedge clk) 
begin
	shift_ip_en_r <= shift_ip_en;
end

always @(posedge clk) 
begin
	shift_ip_en_rr <= shift_ip_en_r;
end

//shift_ip_flag
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		shift_ip_flag <= 1'b0;	
	else if (shift_ip_en_r == 1'b1 && tx_cnt[0] == 1'b1)
		shift_ip_flag <= 1'b1;
	else 
		shift_ip_flag <= 1'b0;
end

//ip_sum
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		ip_sum <= 'd0;	
	else if (shift_ip_en_rr == 1'b1 && shift_ip_en_r == 1'b0)
		ip_sum <= 'd0;
	else if (shift_ip_flag == 1'b1)
		ip_sum <= ip_sum + shift_ip_data;
end

//ip_checksum
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		ip_checksum <= 'd0;	
	else if (shift_ip_en_rr == 1'b1 && shift_ip_en_r == 1'b0)
		ip_checksum <= ~(ip_sum[15:0] + ip_sum[31:16]);
end

//-----------------------------------------------------
//udp checksum

//shift_udp_en
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		shift_udp_en <= 1'b0;	
	else if (tx_en == 1'b1 && tx_cnt == UDP_END_CNT)	
		shift_udp_en <= 1'b0;
	else if (tx_en == 1'b1 && tx_cnt == UDP_START_CNT)
		shift_udp_en <= 1'b1;
end

//shift_udp_data
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		shift_udp_data <= 'd0;	
	else if (shift_udp_en == 1'b1)
		shift_udp_data <= {shift_udp_data[7:0], tx_data};
	else
		shift_udp_data <= 'd0;
end

//shift_udp_en_r
always @(posedge clk) 
begin
	shift_udp_en_r <= shift_udp_en;
end

always @(posedge clk) 
begin
	shift_udp_en_rr <= shift_udp_en_r;
end

//shift_udp_flag
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		shift_udp_flag <= 1'b0;	
	else if (shift_udp_en_r == 1'b1 && tx_cnt[0] == 1'b1)
		shift_udp_flag <= 1'b1;
	else 
		shift_udp_flag <= 1'b0;
end

//udp_sum
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		udp_sum <= IP_VIRT_DATA;	
	else if (shift_udp_en_rr == 1'b1 && shift_udp_en_r == 1'b0)
		udp_sum <= IP_VIRT_DATA;
	else if (shift_udp_flag == 1'b1)
		udp_sum <= udp_sum + shift_udp_data;
end

//udp_checksum
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		udp_checksum <= 'd0;	
	else if (shift_udp_en_rr == 1'b1 && shift_udp_en_r == 1'b0)
		udp_checksum <= ~(udp_sum[15:0] + udp_sum[31:16]);
end

//-------------------------------------------------
//add checksum

bram_wr8x256 inst_bram_wr8x256 (
  .clka(clk),    // input wire clka
  .ena(tx_en),      // input wire ena
  .wea(tx_en),      // input wire [0 : 0] wea
  .addra(tx_cnt),  // input wire [7 : 0] addra
  .dina(tx_data),    // input wire [7 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(rd_en),      // input wire enb
  .addrb(rd_addr),  // input wire [7 : 0] addrb
  .doutb(rd_data)  // output wire [7 : 0] doutb
);

//rd_en
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rd_en <= 1'b0;
	else if (rd_en == 1'b1 && rd_addr == RD_END_CNT)
		rd_en <= 1'b0;
	else if (tx_end_flag == 1'b1)
		rd_en <= 1'b1;
end

always @(posedge clk) 
begin
	rd_en_r <= rd_en;	
end

//rd_addr
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rd_addr <= 'd0;	
	else if (rd_en == 1'b1 && rd_addr == RD_END_CNT)
		rd_addr <= 'd0;
	else if (rd_en == 1'b1)
		rd_addr <= rd_addr + 1'b1;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		checksum_data <= 'd0;	
	else if (rd_en_r == 1'b1 && rd_addr == IP_CHECK_START)
		checksum_data <= ip_checksum[15:8];
	else if (rd_en_r == 1'b1 && rd_addr == IP_CHECK_END)
		checksum_data <= ip_checksum[7:0];
	else if (rd_en_r == 1'b1 && rd_addr == UDP_CHECK_START)
		checksum_data <= udp_checksum[15:8];
	else if (rd_en_r == 1'b1 && rd_addr == UDP_CHECK_END)
		checksum_data <= udp_checksum[7:0];
	else if (rd_en_r == 1'b1)
		checksum_data <= rd_data;
end

always @(posedge clk) 
begin
	checksum_en <= rd_en_r;	
end

endmodule
