// -----------------------------------------------------------------------------
// Copyright (c) 2014-2019 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : ddr3_hdmi.v
// Create : 2019-10-29 16:14:50
// Revise : 2019-10-31 11:06:19
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module ddr3_hdmi(
	  // Inouts
	inout [15:0]       ddr3_dq,
	inout [1:0]        ddr3_dqs_n,
	inout [1:0]        ddr3_dqs_p,
	// Outputs
	output [13:0]     ddr3_addr,
	output [2:0]        ddr3_ba,
	output            ddr3_ras_n,
	output            ddr3_cas_n,
	output            ddr3_we_n,
	output            ddr3_reset_n,
	output [0:0]       ddr3_ck_p,
	output [0:0]       ddr3_ck_n,
	output [0:0]       ddr3_cke,
	output [0:0]        ddr3_cs_n,
	output [1:0]     ddr3_dm,
	output [0:0]       ddr3_odt,
	//user interface
  	input	wire 		clk,
	input 	wire 		rst_n
    );

wire sys_clk;
wire ui_clk;
wire ui_clk_sync_rst;
wire init_calib_complete;

//ddr3 write control
wire    [127:0]     data_128bit;
wire                wr_cmd_start;
wire    [6:0]       wr_cmd_bl;
wire    [27:0]      wr_cmd_addr;
wire    [2:0]       wr_cmd_instr;
wire    [15:0]      wr_cmd_mask;
wire                data_req;
//
wire    [27:0]       app_addr;
wire    [2:0]       app_cmd;
wire                app_en;
wire    [127:0]        app_wdf_data;
wire                app_wdf_end;
wire    [15:0]        app_wdf_mask;
wire                app_wdf_wren;
wire     [127:0]       app_rd_data;
wire                app_rd_data_end;
wire                app_rd_data_valid;
wire                app_rdy;
wire                app_wdf_rdy;
wire                 app_sr_active;
wire                 app_ref_ack;
wire                 app_zq_ack;

  ddr3_clk_gen inst_ddr3_clk_gen
   (
    // Clock out ports
    .clk_out1(sys_clk),     // output clk_out1
   // Clock in ports
    .clk_in1(clk));      // input clk_in1

 ddr3_ctrl u_ddr3_ctrl (

    // Memory interface ports
    .ddr3_addr                      (ddr3_addr),  // output [13:0]		ddr3_addr
    .ddr3_ba                        (ddr3_ba),  // output [2:0]		ddr3_ba
    .ddr3_cas_n                     (ddr3_cas_n),  // output			ddr3_cas_n
    .ddr3_ck_n                      (ddr3_ck_n),  // output [0:0]		ddr3_ck_n
    .ddr3_ck_p                      (ddr3_ck_p),  // output [0:0]		ddr3_ck_p
    .ddr3_cke                       (ddr3_cke),  // output [0:0]		ddr3_cke
    .ddr3_ras_n                     (ddr3_ras_n),  // output			ddr3_ras_n
    .ddr3_reset_n                   (ddr3_reset_n),  // output			ddr3_reset_n
    .ddr3_we_n                      (ddr3_we_n),  // output			ddr3_we_n
    .ddr3_dq                        (ddr3_dq),  // inout [15:0]		ddr3_dq
    .ddr3_dqs_n                     (ddr3_dqs_n),  // inout [1:0]		ddr3_dqs_n
    .ddr3_dqs_p                     (ddr3_dqs_p),  // inout [1:0]		ddr3_dqs_p
    .init_calib_complete            (init_calib_complete),  // output			init_calib_complete
      
	.ddr3_cs_n                      (ddr3_cs_n),  // output [0:0]		ddr3_cs_n
    .ddr3_dm                        (ddr3_dm),  // output [1:0]		ddr3_dm
    .ddr3_odt                       (ddr3_odt),  // output [0:0]		ddr3_odt
    // Application interface ports
    .app_addr                       (app_addr),  // input [27:0]		app_addr
    .app_cmd                        (app_cmd),  // input [2:0]		app_cmd
    .app_en                         (app_en),  // input				app_en
    .app_wdf_data                   (app_wdf_data),  // input [127:0]		app_wdf_data
    .app_wdf_end                    (app_wdf_wren),  // input				app_wdf_end
    .app_wdf_wren                   (app_wdf_wren),  // input				app_wdf_wren
    .app_rd_data                    (app_rd_data),  // output [127:0]		app_rd_data
    .app_rd_data_end                (app_rd_data_end),  // output			app_rd_data_end
    .app_rd_data_valid              (app_rd_data_valid),  // output			app_rd_data_valid
    .app_rdy                        (app_rdy),  // output			app_rdy
    .app_wdf_rdy                    (app_wdf_rdy),  // output			app_wdf_rdy
    .app_sr_req                     (1'b0),  // input			app_sr_req
    .app_ref_req                    (1'b0),  // input			app_ref_req
    .app_zq_req                     (1'b0),  // input			app_zq_req
    .app_sr_active                  (app_sr_active),  // output			app_sr_active
    .app_ref_ack                    (app_ref_ack),  // output			app_ref_ack
    .app_zq_ack                     (app_zq_ack),  // output			app_zq_ack
    .ui_clk                         (ui_clk),  // output			ui_clk
    .ui_clk_sync_rst                (ui_clk_sync_rst),  // output			ui_clk_sync_rst
    .app_wdf_mask                   (app_wdf_mask),  // input [15:0]		app_wdf_mask
    // System Clock Ports
    .sys_clk_i                       (sys_clk),  // input			sys_clk_i
    .sys_rst                        (rst_n) // input sys_rst
    );

A7_wr_ctrl inst_A7_wr_ctrl(
		.app_addr        (app_addr),
		.app_cmd         (app_cmd),
		.app_en          (app_en),
		.app_wdf_data    (app_wdf_data),
		.app_wdf_mask    (app_wdf_mask),
		.app_wdf_wren    (app_wdf_wren),
		.app_rdy         (app_rdy),
		.app_wdf_rdy     (app_wdf_rdy),
		.clk             (ui_clk),
		.rst             (ui_clk_sync_rst|(~init_calib_complete)),
		.data_128bit     (data_128bit),
		.wr_cmd_start    (wr_cmd_start),
		.wr_cmd_bl       (wr_cmd_bl),
		.wr_cmd_addr     (wr_cmd_addr),
		.wr_cmd_instr    (wr_cmd_instr),
		.wr_cmd_mask     (wr_cmd_mask),
		.data_req        (data_req),
		.wr_end          (wr_end)
	);


endmodule
