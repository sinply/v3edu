// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : gen_frame_ctrl.v
// Create : 2020-02-10 20:35:20
// Revise : 2020-02-10 21:04:07
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module gen_frame_ctrl(
	input 	wire 			tx_clk,
	input 	wire 			rst,
	input 	wire 			timer_pulse,
	output 	reg 			tx_en,
	output 	reg 	[7:0]	tx_data
    );

parameter 	PKG_END 	= 113;

parameter 	MAC_DEST5 	= 8'hff,
			MAC_DEST4 	= 8'hff,
			MAC_DEST3 	= 8'hff,
			MAC_DEST2 	= 8'hff,
			MAC_DEST1 	= 8'hff,
			MAC_DEST0 	= 8'hff,

			MAC_SRC5 	= 8'hA8,
			MAC_SRC4 	= 8'hBB,
			MAC_SRC3 	= 8'hC8,
			MAC_SRC2 	= 8'h07,
			MAC_SRC1 	= 8'hD9,
			MAC_SRC0 	= 8'h9F;

parameter 	IP_SRC3 	= 8'd192,
			IP_SRC2 	= 8'd168,
			IP_SRC1 	= 8'd0,
			IP_SRC0 	= 8'd1,

			IP_DEST3 	= 8'd255,
			IP_DEST2 	= 8'd255,
			IP_DEST1 	= 8'd255,
			IP_DEST0 	= 8'd255;	

parameter 	PORT_SRC1 	= 8'h04,
			PORT_SRC0 	= 8'hD2,
			PORT_DEST1 	= 8'h00,
			PORT_DEST0 	= 8'h7B;

reg 			gen_frame_flag;
reg 	[7:0]	gen_frame_cnt;

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		gen_frame_flag <= 1'b0;
	else if (gen_frame_flag == 1'b1 && gen_frame_cnt == PKG_END)
		gen_frame_flag <= 1'b0;
	else if (timer_pulse == 1'b1)
		gen_frame_flag <= 1'b1;
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		gen_frame_cnt <= 'd0;	
	else if (gen_frame_flag == 1'b1)
		gen_frame_cnt <= gen_frame_cnt + 1'b1;
	else
		gen_frame_cnt <= 'd0;
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		tx_data <= 'd0;
	else if (gen_frame_flag == 1'b1)
	begin
		case(gen_frame_cnt)
			0, 1, 2, 3, 4, 5, 6			: tx_data <= 8'h55;
			7							: tx_data <= 8'hD5;
			8							: tx_data <= MAC_DEST5;
			9							: tx_data <= MAC_DEST4;
			10							: tx_data <= MAC_DEST3;
			11							: tx_data <= MAC_DEST2;
			12							: tx_data <= MAC_DEST1;
			13							: tx_data <= MAC_DEST0;
			14							: tx_data <= MAC_SRC5;
			15							: tx_data <= MAC_SRC4;
			16							: tx_data <= MAC_SRC3;
			17							: tx_data <= MAC_SRC2;
			18							: tx_data <= MAC_SRC1;
			19							: tx_data <= MAC_SRC0;
			20							: tx_data <= 8'h08;
			21							: tx_data <= 8'h00;
			22							: tx_data <= 8'h45;
			23							: tx_data <= 8'h00;
			24							: tx_data <= 8'h00;
			25							: tx_data <= 8'h5C;
			26							: tx_data <= 8'h00;
			27							: tx_data <= 8'h00;
			28							: tx_data <= 8'h00;
			29							: tx_data <= 8'h00;
			30							: tx_data <= 8'h80;
			31							: tx_data <= 8'h11;
			32							: tx_data <= 8'h00;
			33							: tx_data <= 8'h00;
			34							: tx_data <= IP_SRC3;
			35							: tx_data <= IP_SRC2;
			36							: tx_data <= IP_SRC1;
			37							: tx_data <= IP_SRC0;
			38							: tx_data <= IP_DEST3;
			39							: tx_data <= IP_DEST2;
			40							: tx_data <= IP_DEST1;
			41							: tx_data <= IP_DEST0;
			42							: tx_data <= PORT_SRC1;
			43							: tx_data <= PORT_SRC0;
			44							: tx_data <= PORT_DEST1;
			45							: tx_data <= PORT_DEST0;
			46							: tx_data <= 8'h00;
			47							: tx_data <= 8'h48;
			default						: tx_data <= 8'd0;			
		endcase
	end 
end

always @(posedge tx_clk) 
begin
	tx_en <= gen_frame_flag;
end

endmodule
