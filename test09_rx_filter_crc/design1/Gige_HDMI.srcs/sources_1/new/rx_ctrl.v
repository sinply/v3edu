`timescale 1ns / 1ps

module rx_ctrl(
	input 	wire			wr_clk,
	input 	wire 			rst,
	input 	wire 			rd_clk,
	input 	wire			rx_en,
	input 	wire 	[7:0]	rx_data,
	input 	wire 			rd_en,
	output 	wire 	[7:0]	rd_data,
	output 	wire 	[15:0]	rd_status
    );

reg 			status_rd_en;
wire 	[6:0]	rd_data_count;
reg 			rd_en_r;
wire 	[15:0]	pkg_status;
wire 			pkg_end;

	rx_buffer inst_rx_buffer
	(
		.wr_clk  (wr_clk),
		.rd_clk  (rd_clk),
		.wr_en   (rx_en),
		.wr_data (rx_data),
		.rd_en   (rd_en),
		.rd_data (rd_data)
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
		.status_rd_en  (status_rd_en),
		.rd_status     (rd_status),
		.rd_data_count (rd_data_count)
	);

always @(posedge rd_clk) 
begin
	rd_en_r <= rd_en;
end

always @(posedge rd_clk) 
begin
	if (rst == 1'b1) 
		status_rd_en <= 1'b0;
	else if (rd_en_r == 1'b0 && rd_en == 1'b1 && rd_data_count >= 'd1)
		status_rd_en <= 1'b1;
	else 
		status_rd_en <= 1'b0;
end

wire 	[31:0]	probe0;
assign probe0 = {
	pkg_status[13:0],
	rd_en,
	status_rd_en,
	pkg_end,
	rd_status[13:0]
};

ila_0 inst_ila_rx_ctrl (
	.clk(rd_clk), // input wire clk


	.probe0(probe0) // input wire [31:0] probe0
);


endmodule
