// -----------------------------------------------------------------------------
// Copyright (c) 2014-2019 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : tb_top_ddr3_hdmi.v
// Create : 2019-10-29 14:40:38
// Revise : 2019-11-02 08:57:04
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module tb_top_ddr3_hdmi (); /* this is automatically generated */

	reg srst_n;
	reg clk;
	//FOR SIM 
	reg sclk;
	reg rst;
	reg wr_cmd_start;
	reg [2:0] 		wr_cmd_instr;
	reg [27:0]	  	wr_cmd_addr;
	reg [15:0]	  	wr_cmd_mask;
	reg [127:0]		data_128bit;
	reg [6:0]		wr_cmd_bl;	
	reg 			data_req;
	reg 			wr_end;
	//read 
	reg 			rd_cmd_start;
	reg [2:0] 		rd_cmd_instr;
	reg [27:0]	  	rd_cmd_addr;
	reg [6:0]		rd_cmd_bl;	
	reg [127:0] 	rd_data_128bit;
	reg 			rd_data_valid;
	reg [7:0]		error_cnt;
	//arbit
	reg 			rd_req;
	reg 			wr_req;

	initial
	begin
		wr_cmd_start = 0;
		wr_cmd_instr = 0;
		wr_cmd_addr = 0;
		wr_cmd_mask = 0;
		wr_cmd_bl = 64;
		data_128bit = 0;
		rd_cmd_start = 0;
		rd_cmd_instr = 1;
		rd_cmd_addr = 0;
		rd_cmd_bl = 64;
		error_cnt = 0;
		wr_req = 0;
		rd_req = 0;
		force sclk = inst_top_ddr3_hdmi.inst_a7_ddr3_rd_ctrl.sclk;
		force rst = inst_top_ddr3_hdmi.inst_a7_ddr3_rd_ctrl.rst;
		force wr_end = inst_top_ddr3_hdmi.inst_a7_ddr3_wr_ctrl.wr_end;
		force data_req = inst_top_ddr3_hdmi.inst_a7_ddr3_wr_ctrl.data_req;
		force wr_cmd_start = inst_top_ddr3_hdmi.inst_a7_ddr3_wr_ctrl.wr_cmd_start;
		force inst_top_ddr3_hdmi.inst_a7_ddr3_wr_ctrl.wr_cmd_instr = wr_cmd_instr;
		force inst_top_ddr3_hdmi.inst_a7_ddr3_wr_ctrl.wr_cmd_addr = wr_cmd_addr;
		force inst_top_ddr3_hdmi.inst_a7_ddr3_wr_ctrl.wr_cmd_mask = wr_cmd_mask;
		force inst_top_ddr3_hdmi.inst_a7_ddr3_wr_ctrl.data_128bit = data_128bit;
		force inst_top_ddr3_hdmi.inst_a7_ddr3_wr_ctrl.wr_cmd_bl = wr_cmd_bl;
		force rd_cmd_start = inst_top_ddr3_hdmi.inst_a7_ddr3_rd_ctrl.rd_cmd_start;
		force inst_top_ddr3_hdmi.inst_a7_ddr3_rd_ctrl.rd_cmd_instr = rd_cmd_instr;
		force inst_top_ddr3_hdmi.inst_a7_ddr3_rd_ctrl.rd_cmd_addr = rd_cmd_addr;
		force inst_top_ddr3_hdmi.inst_a7_ddr3_rd_ctrl.rd_cmd_bl = rd_cmd_bl;
		force rd_data_128bit =  inst_top_ddr3_hdmi.inst_a7_ddr3_rd_ctrl.rd_data_128bit;
		force rd_data_valid = inst_top_ddr3_hdmi.inst_a7_ddr3_rd_ctrl.rd_data_valid;
		force inst_top_ddr3_hdmi.wr_req = wr_req;
		force inst_top_ddr3_hdmi.rd_req = rd_req;
	end

	initial 
	begin
		#100
		gen_cmd();
	end

	initial
	begin
		#100
		gen_data();
	end

	initial
	begin
		#100
		gen_rd_cmd();
	end

	initial
	begin
		#100 
		check_data();
	end

	task gen_cmd;
		integer i;
		begin
			@ (negedge rst);
			repeat (5) @ (posedge sclk);
			wr_req = 1;
			@ (posedge wr_cmd_start);
			wr_req = 0;
		end
	endtask

	task gen_rd_cmd;
		begin
			@ (negedge rst);
			@ (posedge wr_end);
			repeat (5) @ (posedge sclk);
			rd_req = 1;
			@ (posedge rd_cmd_start);
			rd_req = 0;
		end 
	endtask

	task gen_data;
		integer i;
		begin
			@ (posedge data_req); 
			for (i = 0; i < 64; i = i + 1)
			begin
				data_128bit = {96'd0, i[31:0]};
				@ (posedge sclk);
				if (data_req == 1'b0)
					i = i - 1;
			end
			@ (posedge sclk);
			data_128bit = 0;
		end
	endtask

	task check_data;
		integer i;
		begin
			@ (posedge rd_data_valid);
			for (i = 0; i < 64; i = i + 1)
			begin
				#1
				if (i != rd_data_128bit[31:0] && rd_data_valid == 1)
					error_cnt <= error_cnt + 1;
				if (rd_data_valid == 0)
					i = i - 1;
				@ (posedge sclk);
			end
			if (error_cnt == 0)
				$display("checked success !");
			else 
				$display("checked error ! error_cnt = %2d", error_cnt);
		end
	endtask

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
