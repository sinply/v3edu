// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : top_ddr3_hdmi.v
// Create : 2019-10-29 14:20:47
// Revise : 2020-02-04 16:33:41
// Editor : sublime text3, tab size (2)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module top_ddr3_hdmi(
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
	  //system signals
	  input  wire 		sclkin,
	  input  wire 		srst_n
    );

wire sys_clk;
wire init_calib_complete;
wire ui_clk;
wire ui_clk_sync_rst;
//
wire            wr_cmd_start;
wire    [2:0]   wr_cmd_instr;
wire    [6:0]   wr_cmd_bl;
wire    [27:0]  wr_cmd_addr;
wire    [15:0]  wr_cmd_mask;
wire    [127:0] data_128bit;
wire            data_req;
wire            wr_end;
wire            app_wdf_wren;
wire    [127:0] app_wdf_data;
wire            app_wdf_rdy;
wire    [2:0]   app_cmd;
wire            app_en;
wire            app_rdy;
wire    [27:0]  app_addr;
//rd
wire    [127:0] app_rd_data;
wire            app_rd_data_valid;
wire            rd_cmd_start;
wire    [2:0]   rd_cmd_instr;
wire    [6:0]   rd_cmd_bl;
wire    [27:0]  rd_cmd_addr;
wire    [127:0] rd_data_128bit;
wire            rd_data_valid;
wire            rd_end;
//arbit
wire            wr_req;
wire            rd_req;
wire            app_wr_cmd;
wire            app_rd_cmd;
wire            app_wr_en, app_rd_en;
wire    [27:0]  app_wr_addr, app_rd_addr;
//rd_data_fifo
wire 			p1_clk;
wire 			p1_rd_en;
wire 	[127:0]	p1_rd_data;
wire 			p1_rd_data_full;
wire 			p1_rd_data_empty;
wire 	[6:0]	p1_rd_data_count;
//rd cmd fifo
wire 	[6:0]	p1_cmd_bl;
wire 	[2:0]	p1_cmd_instr;
wire 	[27:0]	p1_cmd_addr;
wire 			p1_cmd_en;
wire 			p1_cmd_empty;
//wr cmd fifo
wire			p2_clk;
wire 	[6:0]	p2_cmd_bl;
wire 	[2:0]	p2_cmd_instr;
wire 	[27:0]	p2_cmd_addr;
wire 			p2_cmd_en;
wire 			p2_cmd_empty;
//wr data fifo
wire 	[127:0]	p2_wr_data;
wire 			p2_wr_en;
wire 	[15:0]	p2_wr_mask;
wire 			p2_wr_data_full;
wire 			p2_wr_data_empty;
wire 	[6:0]	p2_wr_data_count;

//user_ctrl
wire          wr_en;
wire [127:0]  wr_data;
wire          user_wr_end;
wire          rd_start;
wire          user_rd_end;

assign app_en = app_wr_en|app_rd_en;
assign app_addr = app_wr_addr|app_rd_addr;
assign app_cmd = (app_wr_en == 1'b1) ? app_wr_cmd : app_rd_cmd;

assign rd_req = ~p1_cmd_empty;
assign wr_req = ~p2_cmd_empty;

 ddr3_clk_gen inst_ddr3_clk_gen
   (
    // Clock out ports
    .clk_out1(sys_clk),     // output clk_out1
   // Clock in ports
    .clk_in1(sclkin));      // input clk_in1

  user_wr_ctrl inst_user_wr_ctrl (
      .clk          (p2_clk),
      .rst          (ui_clk_sync_rst | (~init_calib_complete)),
      .wr_en        (wr_en),
      .wr_data      (wr_data),
      .p2_wr_en     (p2_wr_en),
      .p2_wr_data   (p2_wr_data),
      .p2_wr_mask   (p2_wr_mask),
      .p2_cmd_en    (p2_cmd_en),
      .p2_cmd_bl    (p2_cmd_bl),
      .p2_cmd_instr (p2_cmd_instr),
      .p2_cmd_addr  (p2_cmd_addr),
      .p2_wr_empty  (p2_wr_data_empty),   //时序不一致
      .user_wr_end  (user_wr_end)
    );

    user_rd_ctrl inst_user_rd_ctrl (
      .clk          (p1_clk),
      .rst          (ui_clk_sync_rst | (~init_calib_complete)),
      .rd_start     (rd_start),
      .p1_rd_en     (p1_rd_en),
      .p1_cmd_en    (p1_cmd_en),
      .p1_cmd_instr (p1_cmd_instr),
      .p1_cmd_bl    (p1_cmd_bl),
      .p1_cmd_addr  (p1_cmd_addr),
      .p1_rd_count  (p1_rd_data_count),
      .user_rd_end  (user_rd_end)
    );


rd_data_fifo_ctrl rd_data_fifo_inst (
  .rst(ui_clk_sync_rst | (~init_calib_complete)),                      // input wire rst
  .wr_clk(ui_clk),                // input wire wr_clk
  .rd_clk(p1_clk),                // input wire rd_clk
  .din(rd_data_128bit),                      // input wire [127 : 0] din
  .wr_en(rd_data_valid),                  // input wire wr_en
  .rd_en(p1_rd_en),                  // input wire rd_en
  .dout(p1_rd_data),                    // output wire [127 : 0] dout
  .full(p1_rd_data_full),                    // output wire full
  .empty(p1_rd_data_empty),                  // output wire empty
  .rd_data_count(p1_rd_data_count),  // output wire [6 : 0] rd_data_count
  .wr_rst_busy(),      // output wire wr_rst_busy
  .rd_rst_busy()      // output wire rd_rst_busy
);

cmd_fifo_ctrl rd_cmd_fifo_inst (
  .rst(ui_clk_sync_rst | (~init_calib_complete)),                  // input wire rst
  .wr_clk(p2_clk),            // input wire wr_clk
  .rd_clk(ui_clk),            // input wire rd_clk
  .din({p1_cmd_instr, p1_cmd_bl, p1_cmd_addr}),                  // input wire [37 : 0] din
  .wr_en(p1_cmd_en),              // input wire wr_en
  .rd_en(rd_cmd_start),              // input wire rd_en
  .dout({rd_cmd_instr, rd_cmd_bl, rd_cmd_addr}),                // output wire [37 : 0] dout
  .full(),                // output wire full
  .empty(p1_cmd_empty),              // output wire empty
  .wr_rst_busy(),  // output wire wr_rst_busy
  .rd_rst_busy()  // output wire rd_rst_busy
);

cmd_fifo_ctrl wr_cmd_fifo_inst (
  .rst(ui_clk_sync_rst | (~init_calib_complete)),                  // input wire rst
  .wr_clk(p2_clk),            // input wire wr_clk
  .rd_clk(ui_clk),            // input wire rd_clk
  .din({p2_cmd_instr, p2_cmd_bl, p2_cmd_addr}),                  // input wire [37 : 0] din
  .wr_en(p2_cmd_en),              // input wire wr_en
  .rd_en(wr_cmd_start),              // input wire rd_en
  .dout({wr_cmd_instr, wr_cmd_bl, wr_cmd_addr}),                // output wire [37 : 0] dout
  .full(),                // output wire full
  .empty(p2_cmd_empty),              // output wire empty
  .wr_rst_busy(),  // output wire wr_rst_busy
  .rd_rst_busy()  // output wire rd_rst_busy
);

wr_data_fifo_ctrl wr_data_fifo_inst (
  .rst(ui_clk_sync_rst | (~init_calib_complete)),                      // input wire rst
  .wr_clk(p2_clk),                // input wire wr_clk
  .rd_clk(ui_clk),                // input wire rd_clk
  .din({p2_wr_mask,p2_wr_data}),                      // input wire [143 : 0] din
  .wr_en(p2_wr_en),                  // input wire wr_en
  .rd_en(data_req),                  // input wire rd_en
  .dout({wr_cmd_mask, data_128bit}),                    // output wire [143 : 0] dout
  .full(p2_wr_data_full),                    // output wire full
  .empty(p2_wr_data_empty),                  // output wire empty
  .wr_data_count(p2_wr_data_count),  // output wire [6 : 0] wr_data_count
  .wr_rst_busy(),      // output wire wr_rst_busy
  .rd_rst_busy()      // output wire rd_rst_busy
);

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
    .app_wdf_mask                   (wr_cmd_mask),  // input [15:0]		app_wdf_mask
    // System Clock Ports
    .sys_clk_i                       (sys_clk),  // input			sys_clk_i
    .sys_rst                        (srst_n) // input sys_rst
    );

    a7_ddr3_wr_ctrl inst_a7_ddr3_wr_ctrl
        (
            .sclk         (ui_clk),
            .rst          (ui_clk_sync_rst | (~init_calib_complete)),
            .wr_cmd_start (wr_cmd_start),
            .wr_cmd_instr (wr_cmd_instr),
            .wr_cmd_bl    (wr_cmd_bl),
            .wr_cmd_addr  (wr_cmd_addr),
            .wr_cmd_mask  (wr_cmd_mask),
            .data_128bit  (data_128bit),
            .data_req     (data_req),
            .wr_end       (wr_end),
            .app_wdf_wren (app_wdf_wren),
            .app_wdf_data (app_wdf_data),
            .app_wdf_rdy  (app_wdf_rdy),
            .app_cmd      (app_wr_cmd),
            .app_en       (app_wr_en),
            .app_rdy      (app_rdy),
            .app_addr     (app_wr_addr)
        );

a7_ddr3_rd_ctrl inst_a7_ddr3_rd_ctrl
    (
        .sclk              (ui_clk),
        .rst               (ui_clk_sync_rst | (~init_calib_complete)),
        .rd_cmd_start      (rd_cmd_start),
        .rd_cmd_instr      (rd_cmd_instr),
        .rd_cmd_bl         (rd_cmd_bl),
        .rd_cmd_addr       (rd_cmd_addr),
        .rd_data_128bit    (rd_data_128bit),
        .rd_data_valid     (rd_data_valid),
        .rd_end            (rd_end),
        .app_cmd           (app_rd_cmd),
        .app_en            (app_rd_en),
        .app_rdy           (app_rdy),
        .app_addr          (app_rd_addr),
        .app_rd_data       (app_rd_data),
        .app_rd_data_valid (app_rd_data_valid)
    );

    arbit inst_arbit
        (
            .sclk         (ui_clk),
            .rst          (ui_clk_sync_rst | (~init_calib_complete)),
            .rd_req       (rd_req),
            .wr_req       (wr_req),
            .rd_end       (rd_end),
            .wr_end       (wr_end),
            .rd_cmd_start (rd_cmd_start),
            .wr_cmd_start (wr_cmd_start)
        );

endmodule
