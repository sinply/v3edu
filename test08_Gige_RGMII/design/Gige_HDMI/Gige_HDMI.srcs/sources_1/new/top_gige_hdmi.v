// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : top_gige_hdmi.v
// Create : 2020-02-08 14:34:52
// Revise : 2020-02-08 17:16:54
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module top_gige_hdmi(
	//sys
	input 	wire			clk,
	input 	wire 			rst_n,
	//phy
	input 	wire 			rx_clk,
	output	wire 			phy_rst_n,
	input 	wire 			rx_ctrl,
	input 	wire 	[3:0]	rx_dat
    );

parameter 	TIMER_CNT_END 	= 10;	//100ns/20ns = 5,这里采用两倍，保证足够。

wire 			rst;	
reg 	[7:0]	timer_cnt;	
reg 			phy_rst_n_r = 1'b0;
wire			rx_en;
wire 			rx_clk_90;
wire 	[7:0]	rx_data;

assign rst = ~rst_n;
assign phy_rst_n = phy_rst_n_r;

//phy_rst_n
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		timer_cnt <= 'd0;	
	else if (timer_cnt < TIMER_CNT_END)
		timer_cnt <= timer_cnt + 'd1;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		phy_rst_n_r <= 1'b0;	
	else if (timer_cnt == TIMER_CNT_END)
		phy_rst_n_r <= 1'b1;
end

//rx_clk_90
 pll_rx_clk_90 inst_pll_rx_clk_90
   (
    // Clock out ports
    .rx_clk_90(rx_clk_90),     // output rx_clk_90
   // Clock in ports
    .rx_clk(rx_clk));      // input rx_clk

iddr_ctrl inst_iddr_ctrl
(
	.rx_clk_90 (rx_clk_90),
	.rst_n     (rst_n),
	.rx_dat    (rx_dat),
	.rx_ctrl   (rx_ctrl),
	.rx_en     (rx_en),
	.rx_data   (rx_data)
);

wire [31:0] probe0;

assign probe0 = {
	rx_en,
	rx_data
};

ila_32bit your_instance_name (
	.clk(rx_clk_90), // input wire clk


	.probe0(probe0) // input wire [31:0] probe0
);

endmodule
