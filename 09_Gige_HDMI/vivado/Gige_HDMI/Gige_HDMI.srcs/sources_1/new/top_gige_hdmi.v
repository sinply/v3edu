// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : top_gige_hdmi.v
// Create : 2020-02-08 15:53:05
// Revise : 2020-02-08 16:15:55
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module top_gige_hdmi(
	input 	wire 			clk,
	input 	wire 			rst_n,
	input 	wire 			rx_clk,
	input	wire 			rx_ctrl,
	input 	wire 	[3:0]	rx_dat,
	output 	wire 			phy_rst_n
    );

wire 			rx_clk_90;
reg 	[18:0]	phy_rst_cnt;
wire 			rx_en;
wire 	[7:0]	rx_data;
wire 			rst;

assign phy_rst_n = phy_rst_cnt[18];
assign rst = ~rst_n;

 clk_125_gen inst_clk_125_gen
   (
    // Clock out ports
    .clk_out1(rx_clk_90),     // output clk_out1
   // Clock in ports
    .clk_in1(rx_clk));      // input clk_in1

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		phy_rst_cnt <= 'd0;
	else if (phy_rst_cnt [18] == 1'b0)
		phy_rst_cnt <= phy_rst_cnt + 1'b1;
end

iddr_ctrl inst_iddr_ctrl
	(
		.rx_clk_90 (rx_clk_90),
		.rst       (rst),
		.rx_dat    (rx_dat),
		.rx_ctrl   (rx_ctrl),
		.rx_en     (rx_en),
		.rx_data   (rx_data)
	);

wire 	[31:0]	probe0;
assign probe0 = {
	rx_en,
	rx_data
};

ila_0 inst_ila_top (
	.clk(rx_clk_90), // input wire clk


	.probe0(probe0) // input wire [31:0] probe0
);


endmodule
