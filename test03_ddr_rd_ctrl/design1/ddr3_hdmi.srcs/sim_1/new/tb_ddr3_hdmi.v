// -----------------------------------------------------------------------------
// Copyright (c) 2014-2019 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : tb_ddr3_hdmi.v
// Create : 2019-10-29 16:28:46
// Revise : 2019-10-31 15:44:37
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module tb_ddr3_hdmi (); /* this is automatically generated */

	reg srst;
	reg clk;

	//for sim
	reg 				sclk;
	reg 				rst;
	reg            rd_cmd_start;
	reg    [6:0]   rd_cmd_bl;
	reg    [2:0]   rd_cmd_instr;
	reg    [27:0]  rd_cmd_addr;
	reg 		   rd_data_valid;

	initial
	begin
		rd_cmd_bl = 64;
		rd_cmd_instr = 1;
		rd_cmd_addr = 0;
		//output  
		force sclk = inst_ddr3_hdmi.inst_A7_rd_ctrl.clk;
		force rst =  inst_ddr3_hdmi.inst_A7_rd_ctrl.rst;
		force rd_data_valid =  inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_data_valid;
		//input 
		force inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_cmd_start = rd_cmd_start;
		force inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_cmd_bl = rd_cmd_bl;
		force inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_cmd_addr = rd_cmd_addr;
		force inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_cmd_instr = rd_cmd_instr;
	end 

	initial
	begin
		#500;
		gen_start();
	end

	// initial
	// begin
	// 	#500;
	// 	gen_data();
	// end

	task gen_start;
	begin 
		@ (negedge rst);
		repeat (5) @ (posedge sclk);
		rd_cmd_start = 1;
		@ (posedge sclk);
		rd_cmd_start =0;
		@ (posedge sclk);
	end 
	endtask

	// task gen_data;
	// 	integer i;
	// 	begin 
	// 		@ (posedge rd_data_valid);
	// 		for (i = 0; i < 64; i = i + 1)
	// 		begin
	// 			if (data_req == 1'b0)
	// 				i = i - 1;
	// 			data_128bit = i;
	// 			@ (posedge sclk);
	// 		end
	// 		data_128bit = 0;
	// 		@ (posedge sclk);
	// 	end 
	// endtask

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
