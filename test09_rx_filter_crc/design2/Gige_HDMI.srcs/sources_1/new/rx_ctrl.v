`timescale 1ns / 1ps

module rx_ctrl(
	input 	wire			wr_clk,
	input 	wire 			rst,
	input 	wire 			rd_clk,
	input 	wire			rx_en,
	input 	wire 	[7:0]	rx_data,
	output 	reg 			frx_en,
	output 	reg 	[7:0]	frx_data
    );

reg 			sta_rd_en;
wire 	[15:0]	sta_rd_data;
wire 			sta_rd_empty;
wire 	[15:0]	pkg_status;
wire 			pkg_end;
reg 			rx_buf_rd_en;
wire 	[7:0]	rx_buf_rd_data;
reg 	[13:0]	rx_buf_cnt;
reg 			sta_rd_empty_r;

	rx_buffer inst_rx_buffer
	(
		.wr_clk  (wr_clk),
		.rd_clk  (rd_clk),
		.wr_en   (rx_en),
		.wr_data (rx_data),
		.rd_en   (rx_buf_rd_en),
		.rd_data (rx_buf_rd_data)
	);

	rx_filter inst_rx_filter
	(
		.clk        (wr_clk),
		.rst        (rst),
		.rx_en      (rx_en),
		.rx_data    (rx_data),
		.pkg_status (pkg_status),
		.pkg_end    (pkg_end)
	);

	rx_sta_buffer inst_rx_sta_buffer
		(
			.wr_clk        (wr_clk),
			.rd_clk        (rd_clk),
			.pkg_end       (pkg_end),
			.pkg_status    (pkg_status),
			.status_rd_en  (sta_rd_en),
			.rd_status     (sta_rd_data),
			.rd_sta_empty  (sta_rd_empty)
		);


//sta_rd_en
always @(posedge rd_clk) 
begin
	if (rst == 1'b1) 
		sta_rd_en <= 1'b0;
	else if (sta_rd_empty == 1'b0 && sta_rd_empty_r == 1'b1 && sta_rd_en == 1'b0)
		sta_rd_en <= 1'b1;
	else 
		sta_rd_en <= 1'b0;
end

always @(posedge rd_clk) 
begin
	sta_rd_empty_r <= sta_rd_empty;	
end

//rx_buf_rd_en
always @(posedge rd_clk) 
begin
	if (rst == 1'b1) 
		rx_buf_rd_en <= 1'b0;
	else if (rx_buf_cnt == (sta_rd_data[13:0] - 1) & rx_buf_rd_en == 1'b1)
		rx_buf_rd_en <= 1'b0;
	else if (rx_buf_rd_en == 1'b0 && sta_rd_en == 1'b1)
		rx_buf_rd_en <= 1'b1;
end

//rx_buf_cnt
always @(posedge rd_clk) 
begin
	if (rst == 1'b1) 
		rx_buf_cnt <= 'd0;	
	else if (rx_buf_rd_en == 1'b1)
		rx_buf_cnt <= rx_buf_cnt + 1'b1;
	else 
		rx_buf_cnt <= 'd0;
end

always @(posedge rd_clk) 
begin
	if (rst == 1'b1) 
	begin
		frx_en <= 1'b0;
		frx_data <= 'd0;
	end
	else if (rx_buf_rd_en == 1'b1 && sta_rd_data[15:14] == 2'b11)
	begin
		frx_en <= rx_buf_rd_en;
		frx_data <= rx_buf_rd_data;
	end
	else 
	begin
		frx_en <= 1'b0;
		frx_data <= 'd0;
	end
end

wire 	[63:0]	probe0;

assign probe0 = {
	pkg_end,
	sta_rd_data,
	sta_rd_en,
	rx_data,
	rx_en,
	frx_en, 
	frx_data,
	rx_buf_cnt,
	rx_buf_rd_en,
	rx_buf_rd_data
};

ila_64bit inst_ila_rx_ctrl (
	.clk(rd_clk), // input wire clk


	.probe0(probe0) // input wire [63:0] probe0
);

endmodule
