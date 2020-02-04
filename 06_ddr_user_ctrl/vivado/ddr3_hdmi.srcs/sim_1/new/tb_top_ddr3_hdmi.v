// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : tb_top_ddr3_hdmi.v
// Create : 2019-10-29 14:40:38
// Revise : 2020-02-03 19:00:35
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module tb_top_ddr3_hdmi (); /* this is automatically generated */

	reg srst_n;
	reg clk;
	reg pclk;
	//FOR SIM 
	// reg sclk;
	reg rst;
	reg [2:0] 		wr_cmd_instr;
	reg [27:0]	  	wr_cmd_addr;
	reg [15:0]	  	wr_cmd_mask;

	reg [127:0]		wr_data_128bit;
	reg [6:0]		wr_cmd_bl;	
	reg 			wr_data_en;
	reg 			wr_cmd_en;

	initial
	begin
		wr_cmd_instr = 0;
		wr_cmd_addr = 0;
		wr_cmd_mask = 0;
		wr_cmd_bl = 64;
		wr_data_128bit = 0;
		wr_data_en = 0;
		wr_cmd_en = 0;
		force inst_top_ddr3_hdmi.p1_clk = pclk;
		force inst_top_ddr3_hdmi.p2_clk = pclk;
		force rst = inst_top_ddr3_hdmi.inst_a7_ddr3_wr_ctrl.rst;
		//write data
		force inst_top_ddr3_hdmi.p2_wr_data = wr_data_128bit;
		force inst_top_ddr3_hdmi.p2_wr_en = wr_data_en;
		force inst_top_ddr3_hdmi.p2_wr_mask = wr_cmd_mask;
		//write cmd
		force inst_top_ddr3_hdmi.p2_cmd_en = wr_cmd_en;
		force inst_top_ddr3_hdmi.p2_cmd_instr = wr_cmd_instr;
		force inst_top_ddr3_hdmi.p2_cmd_bl = wr_cmd_bl;
		force inst_top_ddr3_hdmi.p2_cmd_addr = wr_cmd_addr;
	end

	initial begin
		#100 
		wr_data();
	end

	initial begin
		#100
		wr_cmd();
	end

	task wr_data;
		integer i;
		begin
			@ (negedge rst);
			repeat (100) @ (posedge pclk);
			for (i = 0; i < 64; i = i + 1)
			begin
				wr_data_en = 1;
				wr_data_128bit = {96'd0, i};
				@ (posedge pclk);
			end
			wr_data_en = 0;
			wr_data_128bit = 0;
			@ (posedge pclk);
		end
	endtask

	task wr_cmd;
	begin
		@ (negedge wr_data_en);
		@ (posedge pclk);
		wr_cmd_en = 1'b1;
		@ (posedge pclk);
		wr_cmd_en = 1'b0;
	end
	endtask

	// clock
	initial begin
		clk = 0;
		forever #(10) clk = ~clk;
	end

	//pclk 100MHz
	initial begin
		pclk = 0;
		forever #(5) pclk = ~pclk;
	end

	// reset
	initial begin
		srst_n <= 0;
		#200
		repeat (5) @(posedge clk);
		srst_n <= 1;
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

	top_ddr3_hdmi inst_top_ddr3_hdmi
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
			.sclkin       (clk),
			.srst_n       (srst_n)
		);

  ddr3_model u_comp_ddr3
          (
           .rst_n   (ddr3_reset_n),
           .ck      (ddr3_ck_p),
           .ck_n    (ddr3_ck_n),
           .cke     (ddr3_cke),
           .cs_n    (ddr3_cs_n),
           .ras_n   (ddr3_ras_n),
           .cas_n   (ddr3_cas_n),
           .we_n    (ddr3_we_n),
           .dm_tdqs ({ddr3_dm[1],ddr3_dm[0]}),
           .ba      (ddr3_ba),
           .addr    (ddr3_addr),
           .dq      (ddr3_dq[16-1:0]),
           .dqs     ({ddr3_dqs_p[1], ddr3_dqs_p[0]}),
           .dqs_n   ({ddr3_dqs_n[1],ddr3_dqs_n[0]}),
           .tdqs_n  (),
           .odt     (ddr3_odt)
           );


endmodule
