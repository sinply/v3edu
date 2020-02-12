// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : top_gige.v
// Create : 2020-02-11 14:37:45
// Revise : 2020-02-12 15:19:08
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module top_gige #(
	parameter 	SIM_FLAG = 0
	)
	(
		//sys
		input 	wire 			clk,
		input 	wire 			rst_n,
		//phy 
		output 	wire 			tx_clk,
		output 	wire 	[3:0]	tx_dat,
		output 	wire 			tx_ctrl,
		output	wire 			phy_rst_n
    );

wire 			rst;
wire 			timer_pulse;
wire 			tx_en;
wire 	[7:0]	tx_data;
wire 			checksum_en;
wire 	[7:0]	checksum_data;
wire 			pre_flag;
wire 			tx_clk_c;
reg 	[18:0]	phy_rst_cnt;
wire 			dsout;
wire 	[7:0]	dout;
wire 			clk_125;

assign phy_rst_n = phy_rst_cnt[18];
assign rst = ~rst_n;

 pll_clk_125 inst_pll_clk_125
   (
    // Clock out ports
    .clk_out1(clk_125),     // output clk_out1
   // Clock in ports
    .clk_in1(clk));      // input clk_in1

 clk_125_gen inst_clk_125_gen
   (
    // Clock out ports
    .clk_out1(tx_clk_c),     // output clk_out1
   // Clock in ports
    .clk_in1(clk_125));      // input clk_in1

always @(posedge clk_125) 
begin
	if (rst == 1'b1) 
		phy_rst_cnt <= 'd0;
	else if (phy_rst_cnt [18] == 1'b0)
		phy_rst_cnt <= phy_rst_cnt + 1'b1;
end

timer #(
	.SIM_FLAG(SIM_FLAG)
	) 
inst_timer (
	.clk(tx_clk_c),
	.rst(rst), 
	.timer_pulse(timer_pulse)
	);

	gen_frame_ctrl inst_gen_frame_ctrl (
			.clk         (tx_clk_c),
			.rst         (rst),
			.timer_pulse (timer_pulse),
			.tx_en       (tx_en),
			.tx_data     (tx_data)
		);

	add_check_sum inst_add_check_sum (
		.clk           (tx_clk_c),
		.rst           (rst),
		.tx_en         (tx_en),
		.tx_data       (tx_data),
		.checksum_en   (checksum_en),
		.checksum_data (checksum_data),
		.pre_flag	   (pre_flag)
	);

	crc32_d8_send_02 inst_crc32_d8_send_02
		(
			.rst        (rst),
			.sclk       (tx_clk_c),
			.dsin       (checksum_en),
			.din        (checksum_data),
			.pre_flag   (pre_flag),
			.crc_err_en (1'b0),
			.dsout      (dsout),
			.dout       (dout)
		);


	oddr_ctrl inst_oddr_ctrl
		(
			.tx_c    (tx_clk_c),
			.rst     (rst),
			.tx_en   (dsout),
			.tx_data (dout),
			.tx_clk  (tx_clk),
			.tx_ctrl (tx_ctrl),
			.tx_dat  (tx_dat)
		);



endmodule
