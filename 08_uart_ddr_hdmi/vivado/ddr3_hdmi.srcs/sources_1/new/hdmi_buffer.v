// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : hdmi_buffer.v
// Create : 2020-02-05 15:49:59
// Revise : 2020-02-06 17:10:56
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------

module hdmi_buffer(
	input 	wire			wrclk,
	input 	wire 			hdmiclk,
	input 	wire 			rst,
	output 	wire 			rd_start,
	input 	wire			user_rd_end,	
	input 	wire 			rd_data_valid,
	input 	wire	[127:0]	rd_data,
	output 	wire 			hdmi_rst_n,
	input 	wire 			rd_fifo_en,
	output  wire 	[23:0]	rd_fifo_data				
	);

localparam	IDLE 	= 3'b001,
			JUDGE 	= 3'b010,
			RD 		= 3'b100;

wire 	[9:0]	wr_data_count;
wire 	[12:0]	rd_data_count;
reg 	[2:0]	state;
reg 			rd_start_r;
reg 			hdmi_rst_n_r;
wire 	[4:0]	red, blue;
wire 	[5:0]	green;

assign rd_start = rd_start_r;
assign hdmi_rst_n = hdmi_rst_n_r;
assign rd_fifo_data = {red, 3'd0, green, 2'd0, blue, 3'd0};

always @(posedge wrclk) 
begin
	if (rst == 1'b1) 
		state <= IDLE;	
	else 
	begin
		case (state)
			IDLE:
				state <= JUDGE;
			JUDGE:
				if (wr_data_count < 192)
					state <= RD;
			RD:
				if (user_rd_end == 1'b1)
					state <= JUDGE;
			default:
				state <= IDLE;
		endcase
	end
end

always @(posedge wrclk) 
begin
	if (rst == 1'b1) 
		rd_start_r <= 1'b0;
	else if (state == JUDGE && wr_data_count < 192)
		rd_start_r <= 1'b1;
	else 
		rd_start_r <= 1'b0;	
end

asfifo_wr128x512_rd16x4096 inst_hdmi_buffer (
  .wr_clk(wrclk),                // input wire wr_clk
  .rd_clk(hdmiclk),                // input wire rd_clk
  .din(rd_data),                      // input wire [127 : 0] din
  .wr_en(rd_data_valid),                  // input wire wr_en
  .rd_en(rd_fifo_en),                  // input wire rd_en
  .dout({red, green, blue}),                    // output wire [15 : 0] dout
  .full(),                    // output wire full
  .empty(),                  // output wire empty
  .rd_data_count(rd_data_count),  // output wire [12 : 0] rd_data_count
  .wr_data_count(wr_data_count)  // output wire [9 : 0] wr_data_count
);

always @(posedge hdmiclk) 
begin
	if (rst == 1'b1) 
		hdmi_rst_n_r <= 1'b0;
	else if (rd_data_count >= 1500)
		hdmi_rst_n_r <= 1'b1;	
end

// wire [31:0] probe0;
// assign probe0 = {
// 		state,
// 		hdmi_rst_n,
// 		wr_data_count,
// 		rd_start,
// 		rd_data_valid,
// 		rd_fifo_en,
// 		user_rd_end,
// 		green
// };

// ila_0 inst_ila_0 (
// 	.clk(wrclk), // input wire clk


// 	.probe0(probe0) // input wire [31:0] probe0
// );

endmodule 