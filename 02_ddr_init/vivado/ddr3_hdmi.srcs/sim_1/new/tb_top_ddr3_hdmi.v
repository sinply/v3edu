// -----------------------------------------------------------------------------
// Copyright (c) 2014-2019 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : tb_top_ddr3_hdmi.v
// Create : 2019-10-29 14:40:38
// Revise : 2019-10-29 14:55:33
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module tb_top_ddr3_hdmi (); /* this is automatically generated */

	reg srst_n;
	reg clk;

	// clock
	initial begin
		clk = 0;
		forever #(10) clk = ~clk;
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
