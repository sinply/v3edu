`timescale 1ns / 1ps

module checksum_ctrl(
	input 	wire 			tx_clk,
	input 	wire 			rst,
	input 	wire 	[7:0]	tx_gen_data,
	input 	wire 			tx_data_en,
	output 	wire 			tx_en,
	output 	wire 	[7:0]	tx_data
    );

parameter 	IP_S_HEAD = 'hC0A8+'h0001+'hffff+'hffff+'h0011+'h0048;

reg 			tx_data_en_dly;
reg 	[7:0]	tx_gen_data_dly;
reg 	[13:0]	data_cnt;
reg 			shift_ip_en;
reg 	[15:0]	shift_ip_data;
reg 			shift_ip_en_dly;

reg 			ip_add_flag;
reg 	[31:0]	ip_sum;
reg 			ip_end;
reg 	[15:0]	ip_checksum;

reg 			shift_udp_en;
reg				shift_udp_en_dly;
reg 	[15:0]	shift_udp_data;
reg 			shift_udp_flag;
reg 	[31:0]	udp_sum;
reg 			udp_end;
reg 	[15:0]	udp_checksum;

wire 			tx_end_flag;
reg 			rd_en, rd_en_dly;
reg		[11:0]	rd_addr;
wire 	[7:0]	rd_data;
reg 	[7:0]	po_checksum_data;
reg 			po_checksum_en;

assign tx_end_flag = udp_end;
assign tx_en = po_checksum_en;
assign tx_data = po_checksum_data;

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
	begin
		tx_data_en_dly <= 1'b0;			
		tx_gen_data_dly <= 'd0;
	end
	else 
	begin
		tx_data_en_dly <= tx_data_en;
		tx_gen_data_dly <= tx_gen_data;
	end
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		data_cnt <= 'd0;
	else if (tx_data_en_dly == 1'b1)
		data_cnt <= data_cnt + 1'b1;
	else
		data_cnt <= 'd0;
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		shift_ip_en <= 1'b0;
	else if (data_cnt == 'd41)
		shift_ip_en <= 1'b0;
	else if (data_cnt == 'd21 )
		shift_ip_en <= 1'b1;
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		shift_ip_data <= 'd0;
	else if (shift_ip_en == 1'b1)
		shift_ip_data <= {shift_ip_data[7:0], tx_gen_data_dly};	
end

always @(posedge tx_clk) 
begin
	shift_ip_en_dly <= shift_ip_en;	
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		ip_add_flag <= 1'b0;	
	else if (shift_ip_en_dly == 1'b1)
		ip_add_flag <= ip_add_flag + 1'b1;
	else
		ip_add_flag <= 1'b0;
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		ip_sum <= 'd0;
	else if (ip_end == 1'b1)
		ip_sum <= 'd0;
	else if (ip_add_flag == 1'b1)
		ip_sum <= ip_sum + shift_ip_data;
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		ip_end <= 1'b0;
	else if (shift_ip_en == 1'b0 && shift_ip_en_dly == 1'b1)
		ip_end <= 1'b1;
	else
		ip_end <= 1'b0;
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		ip_checksum <= 'd0;
	else if (ip_end == 1'b1)
		ip_checksum <= ~(ip_sum[31:16] + ip_sum[15:0]);
end

blk_wr8x4096 inst_blk_wr8x4096 (
  .clka(tx_clk),    // input wire clka
  .wea(tx_data_en_dly),      // input wire [0 : 0] wea
  .addra(data_cnt),  // input wire [11 : 0] addra
  .dina(tx_gen_data_dly),    // input wire [7 : 0] dina
  .clkb(tx_clk),    // input wire clkb
  .addrb(rd_addr),  // input wire [11 : 0] addrb
  .doutb(rd_data)  // output wire [7 : 0] doutb
);

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		shift_udp_en <= 1'b0;
	else if (data_cnt == 'd113)
		shift_udp_en <= 1'b0;
	else if (data_cnt == 'd41)
		shift_udp_en <= 1'b1;
end

always @(posedge tx_clk) 
begin
	shift_udp_en_dly <= shift_udp_en;
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		shift_udp_data <= 'd0;
	else if (shift_udp_en == 1'b1)
		shift_udp_data <= {shift_udp_data[7:0], tx_gen_data_dly};	
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		shift_udp_flag <= 1'b0;	
	else if (shift_udp_en_dly == 1'b1)
		shift_udp_flag <= shift_udp_flag + 1'b1;
	else 	
		shift_udp_flag <= 1'b0;	
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		udp_sum <= 'd0;
	else if (shift_udp_en == 1'b1 && shift_udp_en_dly == 1'b0)
		udp_sum <= IP_S_HEAD;
	else if (shift_udp_flag == 1'b1)
		udp_sum <= udp_sum + shift_udp_data;	
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		udp_end <= 1'b0;	
	else if (shift_udp_en == 1'b0 && shift_udp_en_dly == 1'b1)
		udp_end <= 1'b1;
	else 
		udp_end <= 1'b0;
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		udp_checksum <= 'd0;
	else if (udp_end == 1'b1)
		udp_checksum <= ~(udp_sum[31:16] + udp_sum[15:0]);
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		rd_en <= 1'b0;
	else if (rd_en == 1'b1 && rd_addr == 'd113)
		rd_en <= 1'b0;
	else if (tx_end_flag == 1'b1)
		rd_en <= 1'b1;	
end

always @(posedge tx_clk) 
begin
	rd_en_dly <= rd_en;
	po_checksum_en <= rd_en_dly;
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		rd_addr <= 'd0;
	else if (rd_en == 1'b1)
		rd_addr <= rd_addr + 1'b1;
	else 
		rd_addr <= 'd0;
end

always @(posedge tx_clk) 
begin
	if (rst == 1'b1) 
		po_checksum_data <= 'd0;	
	else if (rd_en_dly == 1'b1 && rd_addr == 'd33)
		po_checksum_data <= ip_checksum[15:8];
	else if (rd_en_dly == 1'b1 && rd_addr == 'd34)
		po_checksum_data <= ip_checksum[7:0];
	else if (rd_en_dly == 1'b1 && rd_addr == 'd49)
		po_checksum_data <= udp_checksum[15:8];
	else if (rd_en_dly == 1'b1 && rd_addr == 'd50)
		po_checksum_data <= udp_checksum[7:0];	
	else if (rd_en_dly == 1'b1)
		po_checksum_data <= rd_data;
end

endmodule
