// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : tb_ddr3_hdmi.v
// Create : 2019-10-29 16:28:46
// Revise : 2020-02-03 16:34:13
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module tb_ddr3_hdmi (); /* this is automatically generated */

	reg srst;
	reg clk;

	//for sim
	// reg 				sclk;
	reg 				rst;
	// reg            rd_cmd_start;
	// reg    [6:0]   rd_cmd_bl;
	// reg    [2:0]   rd_cmd_instr;
	// reg    [27:0]  rd_cmd_addr;
	// reg 	[127:0]	rd_data_128bit;
	// reg 			rd_data_valid;
	// //
	// reg 		   data_req;
	// // reg            wr_cmd_start;
	// reg    [6:0]   wr_cmd_bl;
	// reg    [2:0]   wr_cmd_instr;
	// reg    [27:0]  wr_cmd_addr;
	// reg    [15:0]  wr_cmd_mask;
	// reg    [127:0]	data_128bit;
	// //arbit 
	// reg 			wr_req;
	// reg 			rd_req;
	// reg 			wr_end;
	// reg 			rd_end;

	//wr_data_fifo_ctrl
	reg 			p2_wr_clk;
	reg 			p2_wr_en;
	reg 	[127:0]	p2_wr_data;
	reg 	[15:0]	p2_wr_mask;
	reg 	[6:0]	p2_wr_count;
	reg 			p2_wr_full;
	reg 			p2_wr_empty;

	//wr_cmd_fifo_ctrl
	reg 			p2_cmd_clk;
	reg 			p2_cmd_en;
	reg 	[2:0]	p2_cmd_instr;
	reg 	[27:0]	p2_cmd_addr;
	reg 	[6:0]	p2_cmd_bl;
	reg 			p2_cmd_full;

	//rd_cmd_fifo_ctrl
	reg 			p1_cmd_clk;
	reg 			p1_cmd_en;
	reg 	[2:0]	p1_cmd_instr;
	reg 	[27:0]	p1_cmd_addr;
	reg 	[6:0]	p1_cmd_bl;
	reg 			p1_cmd_full;

	//rd_data_fifo_ctrl
	reg 			p1_rd_clk;
	reg 			p1_rd_en;
	reg 	[127:0]	p1_rd_data;
	reg 	[6:0]	p1_rd_count;
	reg 			p1_rd_empty;
	reg 			p1_rd_full;

	initial
	begin
		// //read 
		// rd_cmd_bl = 64;
		// rd_cmd_instr = 1;
		// rd_cmd_addr = 0;
		// //write 
		// wr_cmd_mask = 0;
		// wr_cmd_bl = 64;
		// wr_cmd_addr = 0;
		// wr_cmd_instr = 0;
		// //arbit 
		// wr_req = 0;
		// rd_req = 0;
		// //output  
		// force sclk = inst_ddr3_hdmi.inst_A7_arbit.clk;
		force rst =  inst_ddr3_hdmi.inst_A7_arbit.rst;
		// //read 
		// force rd_data_128bit = inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_data_128bit;
		// force rd_data_valid = inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_data_valid;
		// // force inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_cmd_start = rd_cmd_start;
		// force inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_cmd_bl = rd_cmd_bl;
		// force inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_cmd_addr = rd_cmd_addr;
		// force inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_cmd_instr = rd_cmd_instr;
		// //write 
		// force data_req =  inst_ddr3_hdmi.inst_A7_wr_ctrl.data_req; 
		// // force inst_ddr3_hdmi.inst_A7_rd_ctrl.rd_cmd_start = rd_cmd_start;
		// force inst_ddr3_hdmi.inst_A7_wr_ctrl.wr_cmd_bl = wr_cmd_bl;
		// force inst_ddr3_hdmi.inst_A7_wr_ctrl.wr_cmd_addr = wr_cmd_addr;
		// force inst_ddr3_hdmi.inst_A7_wr_ctrl.wr_cmd_instr = wr_cmd_instr;
		// force inst_ddr3_hdmi.inst_A7_wr_ctrl.wr_cmd_mask = wr_cmd_mask;
		// force inst_ddr3_hdmi.inst_A7_wr_ctrl.data_128bit = data_128bit;
		// //arbit
		// force inst_ddr3_hdmi.inst_A7_arbit.wr_req = wr_req;
		// force inst_ddr3_hdmi.inst_A7_arbit.rd_req = rd_req;
		// force wr_end = inst_ddr3_hdmi.inst_A7_arbit.wr_end;
		// force rd_end = inst_ddr3_hdmi.inst_A7_arbit.rd_end;

		//write data fifo 
		p2_wr_clk = 0;
		p2_wr_en = 0;
		p2_wr_data = 0;
		p2_wr_mask = 0;
		//write cmd fifo
		p2_cmd_clk = 0;
		p2_cmd_bl = 64;
		p2_cmd_addr = 0;
		p2_cmd_instr = 0;
		p2_cmd_en = 0;
		//read cmd fifo
		p1_cmd_clk = 0;
		p1_cmd_bl = 64;
		p1_cmd_addr = 0;
		p1_cmd_instr = 1;
		p1_cmd_en = 0;
		//read data fifo
		p1_rd_clk = 0;
		p1_rd_en = 0;

		//write data fifo 
		force p2_wr_full = inst_ddr3_hdmi.inst_wr_data_fifo_ctrl.p2_wr_full;
		force p2_wr_empty = inst_ddr3_hdmi.inst_wr_data_fifo_ctrl.p2_wr_empty;
		force p2_wr_count = inst_ddr3_hdmi.inst_wr_data_fifo_ctrl.p2_wr_count;
		force inst_ddr3_hdmi.inst_wr_data_fifo_ctrl.p2_wr_clk = p2_wr_clk;
	    force inst_ddr3_hdmi.inst_wr_data_fifo_ctrl.p2_wr_en = p2_wr_en;
		force inst_ddr3_hdmi.inst_wr_data_fifo_ctrl.p2_wr_data = p2_wr_data;
        force inst_ddr3_hdmi.inst_wr_data_fifo_ctrl.p2_wr_mask = p2_wr_mask;
		//write cmd fifo 
		force p2_cmd_full = inst_ddr3_hdmi.inst_wr_cmd_fifo_ctrl.p2_cmd_full;
		force inst_ddr3_hdmi.inst_wr_cmd_fifo_ctrl.p2_cmd_clk = p2_cmd_clk;
		force inst_ddr3_hdmi.inst_wr_cmd_fifo_ctrl.p2_cmd_en = p2_cmd_en;
		force inst_ddr3_hdmi.inst_wr_cmd_fifo_ctrl.p2_cmd_bl = p2_cmd_bl;
		force inst_ddr3_hdmi.inst_wr_cmd_fifo_ctrl.p2_cmd_addr = p2_cmd_addr;
		force inst_ddr3_hdmi.inst_wr_cmd_fifo_ctrl.p2_cmd_instr = p2_cmd_instr;
		//read cmd fifo
		force p1_cmd_full = inst_ddr3_hdmi.inst_rd_cmd_fifo_ctrl.p1_cmd_full;
		force inst_ddr3_hdmi.inst_rd_cmd_fifo_ctrl.p1_cmd_clk = p1_cmd_clk;
		force inst_ddr3_hdmi.inst_rd_cmd_fifo_ctrl.p1_cmd_en = p1_cmd_en;
		force inst_ddr3_hdmi.inst_rd_cmd_fifo_ctrl.p1_cmd_bl = p1_cmd_bl;
		force inst_ddr3_hdmi.inst_rd_cmd_fifo_ctrl.p1_cmd_addr = p1_cmd_addr;
		force inst_ddr3_hdmi.inst_rd_cmd_fifo_ctrl.p1_cmd_instr = p1_cmd_instr;
		//read data fifo
		force p1_rd_data = inst_ddr3_hdmi.inst_rd_data_fifo_ctrl.p1_rd_data;
		force p1_rd_count = inst_ddr3_hdmi.inst_rd_data_fifo_ctrl.p1_rd_count;
		force p1_rd_full = inst_ddr3_hdmi.inst_rd_data_fifo_ctrl.p1_rd_full;
		force p1_rd_empty = inst_ddr3_hdmi.inst_rd_data_fifo_ctrl.p1_rd_empty;
		force inst_ddr3_hdmi.inst_rd_data_fifo_ctrl.p1_rd_clk = p1_rd_clk;
		force inst_ddr3_hdmi.inst_rd_data_fifo_ctrl.p1_rd_en = p1_rd_en;
	end 

	//fifo clock
	always #10 p2_wr_clk = ~ p2_wr_clk;
	always #10 p2_cmd_clk = ~ p2_cmd_clk;
	always #10 p1_cmd_clk = ~ p1_cmd_clk;
	always #10 p1_rd_clk = ~ p1_rd_clk;

	initial begin
		gen_wr_data();
	end

	initial begin
		gen_wr_cmd();
	end

	initial begin
		gen_rd_cmd();
	end

	initial begin
		get_rd_data();
	end

	task get_rd_data;
		integer i;
		begin
			@ (negedge rst);
			@ (negedge p1_rd_empty);			//等待fifo非空
			p1_rd_en = 1;
			for (i = 0; i < p1_cmd_bl; i = i + 1)
			begin
				#1
				if (i == p1_rd_data)
					$display("read %2d right!", p1_rd_data);
				else 
					$display("read %2d error!", p1_rd_data);
				@ (posedge p1_rd_clk);
			end
			@ (posedge p1_rd_empty);			//等待fifo为空
			p1_rd_en = 0;
		end
	endtask

	task gen_rd_cmd;
	begin
		@ (negedge rst);
		@ (posedge p2_wr_empty);	//等待写入数据fifo为空，即数据全部写入ddr3中
		p1_cmd_en = 1;
		@ (posedge p1_cmd_clk);
		p1_cmd_en = 0;
	end
	endtask

	task gen_wr_cmd;
	begin
		@ (negedge rst);
		@ (negedge p2_wr_en);		//等待数据完全写入fifo中
		p2_cmd_en = 1;
		@ (posedge p2_cmd_clk);
		p2_cmd_en = 0;
	end
	endtask

	task gen_wr_data;
		integer i;
		begin
			@ (negedge rst);
			repeat (5) @ (posedge p2_wr_clk);
			p2_wr_en = 1;
			for (i = 0; i < 64; i = i + 1)
			begin
				p2_wr_data = i;
				@ (posedge p2_wr_clk);
			end
			p2_wr_en = 0;
			@ (posedge p2_wr_clk);
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
