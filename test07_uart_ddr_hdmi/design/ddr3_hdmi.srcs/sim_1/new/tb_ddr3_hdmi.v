// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : tb_ddr3_hdmi.v
// Create : 2019-10-29 16:28:46
// Revise : 2020-02-06 15:40:25
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module tb_ddr3_hdmi (); /* this is automatically generated */

	reg srst;
	reg clk;

	//for sim
	reg 				rst;
	reg 				pclk;

	//user_ctrl
	reg 			wr_en;
	reg 	[7:0]	wr_data;

	initial
	begin
		wr_en = 0;
		wr_data = 0;

		//system
		force rst =  inst_ddr3_hdmi.inst_A7_arbit.rst;
		force inst_ddr3_hdmi.inst_wr_data_fifo_ctrl.p2_wr_clk = pclk;
		force inst_ddr3_hdmi.inst_wr_cmd_fifo_ctrl.p2_cmd_clk = pclk;
		force inst_ddr3_hdmi.inst_rd_cmd_fifo_ctrl.p1_cmd_clk = pclk;
		force inst_ddr3_hdmi.inst_rd_data_fifo_ctrl.p1_rd_clk = pclk;

		//bit8to128
		force inst_ddr3_hdmi.inst_bit8to128.po_flag = wr_en;
		force inst_ddr3_hdmi.inst_bit8to128.po_data = wr_data;
	end 

	//fifo clock
	initial begin
		pclk = 0;
		forever #(5) pclk = ~pclk;
	end

	initial begin
		#100
		gen_wr_data();
	end

	task gen_wr_data;
		integer i;
		begin
			@ (negedge rst);
			repeat (100) @ (posedge clk);
			wr_en = 1;
			for (i = 0; i < 512; i = i + 1)
			begin
				wr_data = i[7:0];
				@ (posedge clk);
			end
			wr_en = 0;
			@ (posedge clk);
			wr_en = 1;
			for (i = 0; i < 512; i = i + 1)
			begin
				wr_data = i[7:0];
				@ (posedge clk);
			end
			wr_en = 0;
		end
	endtask

	//------------------------------------------------------------
	//----------------------system control------------------------
	// clock
	initial begin
		clk = 0;
		forever #(10) clk = ~clk;
	end

	// reset
	initial begin
		srst <= 0;
		#200
		repeat (5) @(posedge clk);
		srst <= 1;
	end

	// (*NOTE*) replace reset, clock, others

	wire [15:0] ddr3_dq;
	wire  [1:0] ddr3_dqs_n;
	wire  [1:0] ddr3_dqs_p;
	wire [13:0] ddr3_addr;
	wire  [2:0] ddr3_ba;
	wire        ddr3_ras_n;
	wire        ddr3_cas_n;
	wire        ddr3_we_n;
	wire        ddr3_reset_n;
	wire  [0:0] ddr3_ck_p;
	wire  [0:0] ddr3_ck_n;
	wire  [0:0] ddr3_cke;
	wire  [0:0] ddr3_cs_n;
	wire  [1:0] ddr3_dm;
	wire  [0:0] ddr3_odt;
	wire        rst_n;

	assign rst_n = srst;

	ddr3_model inst_ddr3_model (
		.rst_n   (ddr3_reset_n),
		.ck      (ddr3_ck_p),
		.ck_n    (ddr3_ck_n),
		.cke     (ddr3_cke),
		.cs_n    (ddr3_cs_n),
		.ras_n   (ddr3_ras_n),
		.cas_n   (ddr3_cas_n),
		.we_n    (ddr3_we_n),
		.dm_tdqs (ddr3_dm),
		.ba      (ddr3_ba),
		.addr    (ddr3_addr),
		.dq      (ddr3_dq),
		.dqs     (ddr3_dqs_p),
		.dqs_n   (ddr3_dqs_n),
		.tdqs_n  (),
		.odt     (ddr3_odt)
	);


	ddr3_hdmi inst_ddr3_hdmi
		(
			.ddr3_dq      (ddr3_dq),
			.ddr3_dqs_n   (ddr3_dqs_n),
			.ddr3_dqs_p   (ddr3_dqs_p),
			.ddr3_addr    (ddr3_addr),
			.ddr3_ba      (ddr3_ba),
			.ddr3_ras_n   (ddr3_ras_n),
			.ddr3_cas_n   (ddr3_cas_n),
			.ddr3_we_n    (ddr3_we_n),
			.ddr3_reset_n (ddr3_reset_n),
			.ddr3_ck_p    (ddr3_ck_p),
			.ddr3_ck_n    (ddr3_ck_n),
			.ddr3_cke     (ddr3_cke),
			.ddr3_cs_n    (ddr3_cs_n),
			.ddr3_dm      (ddr3_dm),
			.ddr3_odt     (ddr3_odt),
			.clk          (clk),
			.rst_n        (rst_n)
		);

endmodule
