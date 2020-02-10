// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : rx_filter_buffer.v
// Create : 2020-02-09 17:20:58
// Revise : 2020-02-09 21:18:43
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module rx_filter_buffer(
	input	wire 			clk,
	input 	wire 			rst,
	input 	wire 			rx_en,
	input 	wire 	[7:0]	rx_data,
	output 	reg 			frx_en,
	output	reg 	[7:0]	frx_data
	);

wire 			rx_buffer_wr_en;
wire 	[7:0]	rx_buffer_wr_data;
reg 			rx_buffer_rd_en;
wire 	[7:0]	rx_buffer_rd_data;
reg 	[13:0]	rx_buffer_rd_cnt;
wire 			rx_buffer_full, rx_buffer_empty;
reg 	[13:0]	rx_cnt;
reg 	[13:0]	rx_cnt_buf;
reg 			rx_en_t;
reg 	[3:0]	filter_cnt;
reg 			vld_pkg;
reg 			rx_en_new;
wire 			pkg_end;
wire 			crc32_error;
wire 	[15:0]	pkg_staus;
wire 			rx_sta_full, rx_sta_empty;
reg 			read_proc_flag;
reg 			read_sta_en;
wire  	[15:0]	status;
reg 	[15:0]	status_r;

assign rx_buffer_wr_en = rx_en;
assign rx_buffer_wr_data = rx_data;
assign pkg_staus = {~crc32_error, vld_pkg, rx_cnt_buf};

asfifo_wr8x8192 inst_rx_buffer (
  .wr_clk(clk),  // input wire wr_clk
  .rd_clk(clk),  // input wire rd_clk
  .din(rx_buffer_wr_data),        // input wire [7 : 0] din
  .wr_en(rx_buffer_wr_en),    // input wire wr_en
  .rd_en(rx_buffer_rd_en),    // input wire rd_en
  .dout(rx_buffer_rd_data),      // output wire [7 : 0] dout
  .full(rx_buffer_full),      // output wire full
  .empty(rx_buffer_empty)    // output wire empty
);

//rx_filter start

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rx_cnt <= 'd0;	
	else if (rx_en == 1'b1)
		rx_cnt <= rx_cnt + 1'b1;
	else
		rx_cnt <= 'd0;	
end

always @(posedge clk) 
begin
	rx_en_t <= rx_en;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rx_cnt_buf <= 'd0;
	else if (rx_en == 1'b0 && rx_en_t == 1'b1)
		rx_cnt_buf <= rx_cnt;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		filter_cnt <= 'd0;	
	else if (rx_en == 1'b1 && rx_cnt == 'd31 && rx_data == 8'h11) //udp
		filter_cnt <= filter_cnt + 1'b1;
	else if (rx_en == 1'b1 && rx_cnt == 'd42 && rx_data == 8'h04) //source port
		filter_cnt <= filter_cnt + 1'b1;
	else if (rx_en == 1'b1 && rx_cnt == 'd43 && rx_data == 8'hD2)
		filter_cnt <= filter_cnt + 1'b1;
	else if (rx_en == 1'b1 && rx_cnt == 'd44 && rx_data == 8'h00) //dest port
		filter_cnt <= filter_cnt + 1'b1;
	else if (rx_en == 1'b1 && rx_cnt == 'd45 && rx_data == 8'h7B)
		filter_cnt <= filter_cnt + 1'b1;
	else if (rx_en == 1'b0)
		filter_cnt <= 'd0;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		vld_pkg <= 1'b0;	
	else if (rx_en == 1'b0 && rx_en_t == 1'b1 && filter_cnt == 'd5)	//5 condition filters
		vld_pkg <= 1'b1;
	else if (rx_en == 1'b0 && rx_en_t == 1'b1 && filter_cnt != 'd5)
		vld_pkg <= 1'b0;	
end

always @(posedge clk or negedge rx_en) 
begin
	if (rx_en == 1'b0) 
		rx_en_new <= 1'b0;
	else if (rx_cnt == 'd7)
		rx_en_new <= 1'b1;
end

	crc32_d8_rec_02 inst_crc32_d8_rec_02
	(
		.resetb        (1'b1),
		.sclk          (clk),
		.dsin          (rx_en_new),
		.din           (rx_data),
		.crc32_cal_end (pkg_end),
		.crc32_error   (crc32_error)
	);

asfifo_wr16x64 inst_rx_sta_buffer (
  .wr_clk(clk),  // input wire wr_clk
  .rd_clk(clk),  // input wire rd_clk
  .din(pkg_staus),        // input wire [15 : 0] din
  .wr_en(pkg_end),    // input wire wr_en
  .rd_en(read_sta_en),    // input wire rd_en
  .dout(status),      // output wire [15 : 0] dout
  .full(rx_sta_full),      // output wire full
  .empty(rx_sta_empty)    // output wire empty
);

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		read_proc_flag <= 1'b0;	
	else if (rx_buffer_rd_cnt == (status[13:0]-1) && rx_buffer_rd_en == 1'b1)
		read_proc_flag <= 1'b0;
	else if (read_proc_flag == 1'b0 && rx_sta_empty == 1'b0)
		read_proc_flag <= 1'b1;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		read_sta_en <= 1'b0;
	else if (read_sta_en == 1'b1 && read_proc_flag == 1'b1)
		read_sta_en <= 1'b0;
	else if(read_proc_flag == 1'b0 && rx_sta_empty == 1'b0 && read_sta_en == 1'b0)
		read_sta_en <= 1'b1;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		status_r <= 'd0;	
	else if (read_sta_en == 1'b1)
		status_r <= status;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rx_buffer_rd_cnt <= 'd0;	
	else if (rx_buffer_rd_en == 1'b1)
		rx_buffer_rd_cnt <= rx_buffer_rd_cnt + 1'b1;
	else 
		rx_buffer_rd_cnt <= 'd0;	
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
		rx_buffer_rd_en <= 1'b0;
	else if (rx_buffer_rd_cnt == (status[13:0]-1) && rx_buffer_rd_en == 1'b1)
		rx_buffer_rd_en <= 1'b0;	
	else if (read_sta_en == 1'b1)
		rx_buffer_rd_en <= 1'b1;
end

always @(posedge clk) 
begin
	if (rst == 1'b1) 
	begin
		frx_en <= 1'b0;
		frx_data <= 'd0;		
	end	
	else if (rx_buffer_rd_en == 1'b1 && status_r[15] == 1'b1 && status_r[14] == 1'b1)
	begin
		frx_data <= rx_buffer_rd_data;
		frx_en <= 1'b1;
	end
	else 
	begin
		frx_en <= 1'b0;
		frx_data <= 'd0;	
	end	
end

wire 	[63:0]	probe0;
assign probe0 = {
	rx_en, 
	rx_en_t,
	rx_data,
	read_proc_flag,
	rx_sta_empty,
	pkg_end,
	pkg_staus,
	frx_en,
	frx_data,
	read_sta_en,
	rx_buffer_rd_en,
	crc32_error,
	status_r
};

ila_0 inst_ila_rx_filter_buffer (
	.clk(clk), // input wire clk


	.probe0(probe0) // input wire [63:0] probe0
);

endmodule 

