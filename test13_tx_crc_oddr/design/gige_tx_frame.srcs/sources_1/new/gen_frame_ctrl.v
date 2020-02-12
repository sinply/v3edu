// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : gen_frame_ctrl.v
// Create : 2020-02-11 14:10:25
// Revise : 2020-02-11 14:36:48
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module gen_frame_ctrl(
	input 	wire 			clk,
	input 	wire 			rst,
	input 	wire 			timer_pulse,
	output 	reg 			tx_en,
	output 	reg 	[7:0]	tx_data
    );

parameter 		TX_END_CNT = 113;

parameter 		MAC_D5 		= 8'hff,
				MAC_D4 		= 8'hff,
				MAC_D3 		= 8'hff,
				MAC_D2 		= 8'hff,
				MAC_D1 		= 8'hff,
				MAC_D0 		= 8'hff,

				MAC_S5 		= 8'hA8,
				MAC_S4 		= 8'hBB,
				MAC_S3 		= 8'hC8,
				MAC_S2 		= 8'h07,
				MAC_S1 		= 8'hD9,
				MAC_S0 		= 8'h7F;

parameter		IP_S3		= 8'D192,
				IP_S2		= 8'D168,
				IP_S1		= 8'D0,
				IP_S0		= 8'D1,

				IP_D3		= 8'hff,
				IP_D2		= 8'hff,
				IP_D1		= 8'hff,
				IP_D0		= 8'hff;

parameter 		PORT_S1 	= 8'h04,
				PORT_S0 	= 8'hD2,

				PORT_D1 	= 8'h00,
				PORT_D0 	= 8'h7B;

reg 			tx_flag;
reg 	[7:0]	tx_cnt;

//tx_flag
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		tx_flag <= 1'b0;
	else if (tx_flag == 1'b1 && tx_cnt == TX_END_CNT)
		tx_flag <= 1'b0;
	else if (timer_pulse == 1'b1)
		tx_flag <= 1'b1;
end

//tx_cnt
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		tx_cnt <= 'd0;
	else if (tx_flag == 1'b1 && tx_cnt == TX_END_CNT)
		tx_cnt <= 'd0;
	else if (tx_flag == 1'b1)
		tx_cnt <= tx_cnt + 1'b1;
end

//tx_en
always @(posedge clk) 
begin
	tx_en <= tx_flag;	
end

//tx_data
always @(posedge clk) 
begin
	if (rst == 1'b1) 
		tx_data <= 'd0;
	else if (tx_flag == 1'b1)
	begin
		case (tx_cnt)
			0,1,2,3,4,5,6	: 	tx_data <= 8'h55;
			7				:	tx_data <= 8'hD5;
			8				:	tx_data <= MAC_D5;
			9				:	tx_data <= MAC_D4;
			10				:	tx_data <= MAC_D3;
			11				:	tx_data <= MAC_D2;
			12				:	tx_data <= MAC_D1;
			13				:	tx_data <= MAC_D0;
			14				:	tx_data <= MAC_S5;
			15				:	tx_data <= MAC_S4;
			16				:	tx_data <= MAC_S3;
			17				:	tx_data <= MAC_S2;
			18				:	tx_data <= MAC_S1;
			19				:	tx_data <= MAC_S0;
			20				:	tx_data <= 8'h08;
			21				:	tx_data <= 8'h00;
			22				:	tx_data <= 8'h45;
			23				:	tx_data <= 8'h00;
			24				:	tx_data <= 8'h00;
			25				:	tx_data <= 8'h5C;
			26				:	tx_data <= 8'h00;
			27				:	tx_data <= 8'h00;
			28				:	tx_data <= 8'h00;
			29				:	tx_data <= 8'h00;
			30				:	tx_data <= 8'h80;
			31				:	tx_data <= 8'h11;
			32				:	tx_data <= 8'h00;
			33				:	tx_data <= 8'h00;
			34				:	tx_data <= IP_S3;
			35				:	tx_data <= IP_S2;
			36				:	tx_data <= IP_S1;
			37				:	tx_data <= IP_S0;
			38				:	tx_data <= IP_D3;
			39				:	tx_data <= IP_D2;
			40				:	tx_data <= IP_D1;
			41				:	tx_data <= IP_D0;
			42				:	tx_data <= PORT_S1;
			43				:	tx_data <= PORT_S0;
			44				:	tx_data <= PORT_D1;
			45				:	tx_data <= PORT_D0;
			46				:	tx_data <= 8'h00;
			47				:	tx_data <= 8'h48;
			default			:	tx_data <= 8'h00;
		endcase
	end
end

endmodule
