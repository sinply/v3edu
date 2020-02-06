// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : ddr3_hdmi.v
// Create : 2019-10-29 16:14:50
// Revise : 2020-02-06 19:57:05
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
	input 	wire 		rst_n,
	//hdmi interface 
	output	wire 			hdmi_clk_p,
	output	wire 			hdmi_clk_n,
	output	wire 			hdmi_d0_p,
	output	wire 			hdmi_d0_n,
	output	wire 			hdmi_d1_p,
	output	wire 			hdmi_d1_n,
	output	wire 			hdmi_d2_p,
	output	wire 			hdmi_d2_n,
	//uart
	input 	wire 			rx
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
wire    [27:0]       wr_app_addr;
wire    [2:0]       wr_app_cmd;
wire                wr_app_en;
wire                 wr_end;
//ddr3 control
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
//ddr3 read control
wire            rd_cmd_start;
wire    [6:0]   rd_cmd_bl;
wire    [2:0]   rd_cmd_instr;
wire    [27:0]  rd_cmd_addr;
wire            rd_data_valid;
wire    [127:0] rd_data_128bit;
wire            rd_end;
wire    [27:0]      rd_app_addr;
wire    [2:0]       rd_app_cmd;
wire                rd_app_en;
//ddr3 arbit
wire            wr_req;
wire            rd_req;

//-----------------------------------------------
//--------------------fifo_ctrl------------------

//wr_data_fifo_ctrl
wire 			p2_clk;
wire 			p2_wr_en;
wire 	[127:0]	p2_wr_data;
wire 	[15:0]	p2_wr_mask;
wire 	[6:0]	p2_wr_count;
wire 			p2_wr_empty;
wire 			p2_wr_full;

//wr_cmd_fifo_ctrl
wire 			p2_cmd_en;
wire 	[2:0]	p2_cmd_instr;
wire 	[27:0]	p2_cmd_addr;
wire 	[6:0]	p2_cmd_bl;
wire 			p2_cmd_full;
wire 			p2_cmd_empty;

//rd_cmd_fifo_ctrl
wire 			p1_clk;
wire 			p1_cmd_en;
wire 	[2:0]	p1_cmd_instr;
wire 	[27:0]	p1_cmd_addr;
wire 	[6:0]	p1_cmd_bl;
wire 			p1_cmd_full;
wire 			p1_cmd_empty;

//rd_data_fifo_ctrl
wire 			p1_rd_en;
wire 	[127:0]	p1_rd_data;
wire 	[6:0]	p1_rd_count;
wire 			p1_rd_empty;
wire 			p1_rd_full;

//user_wr_ctrl
wire 			wr_en;
wire 	[127:0]	wr_data;
wire 			user_wr_end;
//user_rd_ctrl
wire 			rd_start;
wire 			user_rd_end;

//hdmi
wire 			clk1x;
wire 			clk5x;
wire 			locked;		
wire 	[4:0]	red, blue;
wire 	[5:0]	green;	
wire 	[23:0]	rgb_pixel;	

wire 			temp_clk;
wire 			po_flag;
wire 	[7:0]	po_data;

assign app_addr = wr_app_addr | rd_app_addr;
assign app_cmd = (wr_app_en == 1'b1) ? wr_app_cmd : rd_app_cmd;
assign app_en = wr_app_en | rd_app_en;

assign wr_req = ~p2_cmd_empty;
assign rd_req = ~p1_cmd_empty;

assign rgb_pixel = {red, 3'd0, green, 2'd0, blue, 3'd0};
assign p2_clk = p1_clk;

 ddr3_clk_gen inst_ddr3_clk_gen
   (
    // Clock out ports
    .clk_out1(sys_clk),     // output clk_out1
    .clk_out2(temp_clk),
   // Clock in ports
    .clk_in1(clk));      // input clk_in1

     hdmi_clk_gen inst_hdmi_clk_gen
   (
    // Clock out ports
    .p1_clk(p1_clk),     // output p1_clk
    .clk1x(clk1x),     // output clk1x
    .clk5x(clk5x),     // output clk5x
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(temp_clk));      // input clk_in1

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
		.app_addr        (wr_app_addr),
		.app_cmd         (wr_app_cmd),
		.app_en          (wr_app_en),
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

A7_rd_ctrl inst_A7_rd_ctrl(
        .clk               (ui_clk),
        .rst               (ui_clk_sync_rst|(~init_calib_complete)),
        .rd_cmd_start      (rd_cmd_start),
        .rd_cmd_bl         (rd_cmd_bl),
        .rd_cmd_instr      (rd_cmd_instr),
        .rd_cmd_addr       (rd_cmd_addr),
        .rd_data_valid     (rd_data_valid),
        .rd_data_128bit    (rd_data_128bit),
        .rd_end            (rd_end),
        .app_en            (rd_app_en),
        .app_cmd           (rd_app_cmd),
        .app_addr          (rd_app_addr),
        .app_rdy           (app_rdy),
        .app_rd_data       (app_rd_data),
        .app_rd_data_valid (app_rd_data_valid)
    );

    A7_arbit inst_A7_arbit (
            .clk          (ui_clk),
            .rst          (ui_clk_sync_rst|(~init_calib_complete)),
            .wr_req       (wr_req),
            .rd_req       (rd_req),
            .wr_end       (wr_end),
            .rd_end       (rd_end),
            .wr_cmd_start (wr_cmd_start),
            .rd_cmd_start (rd_cmd_start)
        );

	//fifo_ctrl
	wr_data_fifo_ctrl inst_wr_data_fifo_ctrl
	(
		.p2_wr_clk   (p2_clk),
		.p2_wr_en    (p2_wr_en),
		.p2_wr_data  (p2_wr_data),
		.p2_wr_mask  (p2_wr_mask),
		.p2_wr_count (p2_wr_count),
		.p2_wr_empty (p2_wr_empty),
		.p2_wr_full  (p2_wr_full),
		.p2_rd_clk   (ui_clk),
		.wr_cmd_mask (wr_cmd_mask),
		.data_128bit (data_128bit),
		.data_req    (data_req)
		);

	wr_cmd_fifo_ctrl inst_wr_cmd_fifo_ctrl
	(
		.p2_cmd_clk    (p2_clk),
		.p2_cmd_en     (p2_cmd_en),
		.p2_cmd_instr  (p2_cmd_instr),
		.p2_cmd_addr   (p2_cmd_addr),
		.p2_cmd_bl     (p2_cmd_bl),
		.p2_cmd_full   (p2_cmd_full),
		.p2_cmd_empty  (p2_cmd_empty),
		.p2_cmd_rd_clk (ui_clk),
		.p2_cmd_rd_en  (wr_cmd_start),
		.wr_cmd_bl     (wr_cmd_bl),
		.wr_cmd_addr   (wr_cmd_addr),
		.wr_cmd_instr  (wr_cmd_instr)
	);

	rd_cmd_fifo_ctrl inst_rd_cmd_fifo_ctrl
	(
		.p1_cmd_clk    (p1_clk),
		.p1_cmd_en     (p1_cmd_en),
		.p1_cmd_instr  (p1_cmd_instr),
		.p1_cmd_addr   (p1_cmd_addr),
		.p1_cmd_bl     (p1_cmd_bl),
		.p1_cmd_full   (p1_cmd_full),
		.p1_cmd_empty  (p1_cmd_empty),
		.p1_cmd_rd_clk (ui_clk),
		.p1_cmd_rd_en  (rd_cmd_start),
		.rd_cmd_bl     (rd_cmd_bl),
		.rd_cmd_addr   (rd_cmd_addr),
		.rd_cmd_instr  (rd_cmd_instr)
	);

	rd_data_fifo_ctrl inst_rd_data_fifo_ctrl
	(
		.p1_rd_clk      (p1_clk),
		.p1_rd_en       (p1_rd_en),
		.p1_rd_data     (p1_rd_data),
		.p1_rd_count    (p1_rd_count),
		.p1_rd_empty    (p1_rd_empty),
		.p1_rd_full     (p1_rd_full),
		.p1_wr_clk      (ui_clk),
		.rd_data_valid  (rd_data_valid),
		.rd_data_128bit (rd_data_128bit)
	);

	//user control
	user_wr_ctrl inst_user_wr_ctrl
	(
		.clk          (p2_clk),
		.rst          (ui_clk_sync_rst|(~init_calib_complete)),
		.wr_en        (wr_en),
		.wr_data      (wr_data),
		.p2_wr_empty  (p2_wr_empty),
		.p2_wr_en     (p2_wr_en),
		.p2_wr_data   (p2_wr_data),
		.p2_wr_mask   (p2_wr_mask),
		.p2_cmd_en    (p2_cmd_en),
		.p2_cmd_bl    (p2_cmd_bl),
		.p2_cmd_instr (p2_cmd_instr),
		.p2_cmd_addr  (p2_cmd_addr),
		.user_wr_end  (user_wr_end)
	);

	user_rd_ctrl inst_user_rd_ctrl (
			.clk          (p1_clk),
			.rst          (ui_clk_sync_rst|(~init_calib_complete)),
			.rd_start     (rd_start),
			.p1_rd_count  (p1_rd_count),
			.p1_rd_en     (p1_rd_en),
			.p1_cmd_en    (p1_cmd_en),
			.p1_cmd_bl    (p1_cmd_bl),
			.p1_cmd_instr (p1_cmd_instr),
			.p1_cmd_addr  (p1_cmd_addr),
			.user_rd_end  (user_rd_end)
		);

	hdmi_buffer inst_hdmi_buffer (
			.p1_clk       (p1_clk),
			.vga_clk      (clk1x),
			.rst          (ui_clk_sync_rst|(~init_calib_complete)),
			.p1_rd_en     (p1_rd_en),
			.p1_rd_data   (p1_rd_data),
			.rd_end       (user_rd_end),
			.vga_start    (vga_start),
			.vga_de       (vga_de),
			.rd_start     (rd_start),
			.fifo_rd_data ({red, green, blue})
		);

	hdmi_dis inst_hdmi_dis
	(
		.clk1x       (clk1x),
		.clk5x       (clk5x),
		.rst         (ui_clk_sync_rst|(~init_calib_complete)),
		.locked      (locked),
		// .fifo_rd_en  (fifo_rd_en),
		.rgb_pixel   (rgb_pixel),
		.vga_de      (vga_de),
		.vga_start   (vga_start),
		.hdmi_clk_p  (hdmi_clk_p),
		.hdmi_clk_n  (hdmi_clk_n),
		.hdmi_d0_p (hdmi_d0_p),
		.hdmi_d0_n (hdmi_d0_n),
		.hdmi_d1_p (hdmi_d1_p),
		.hdmi_d1_n (hdmi_d1_n),
		.hdmi_d2_p (hdmi_d2_p),
		.hdmi_d2_n (hdmi_d2_n)
	);

	uart_rx inst_uart_rx (
			.sclk    (p1_clk),				//50MHz
			.rst_n   (init_calib_complete&(~ui_clk_sync_rst)),
			.rx      (rx),
			.po_data (po_data),
			.po_flag (po_flag)
		);

	bit8to128 inst_bit8to128 (
		.clk         (p1_clk),				//50MHz
		.p2_clk      (p2_clk),
		.rst         (ui_clk_sync_rst|(~init_calib_complete)),
		.po_flag     (po_flag),
		.po_data     (po_data),
		.bit128_en   (wr_en),
		.bit128_data (wr_data)
	);


wire [31:0] probe0;

assign probe0 = {
	po_flag,
	rx,
	wr_en,
	po_data,	
	p2_wr_en,
	p2_wr_empty,
	p2_cmd_en,
	p2_cmd_empty,
	user_wr_end
};

ila_hdmi_buffer inst_ila_ddr(
	.clk(p1_clk), // input wire clk


	.probe0(probe0) // input wire [31:0] probe0
);

endmodule
