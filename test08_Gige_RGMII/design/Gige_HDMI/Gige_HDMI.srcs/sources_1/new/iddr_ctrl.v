// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : iddr_ctrl.v
// Create : 2020-02-08 14:21:51
// Revise : 2020-02-08 17:24:25
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module iddr_ctrl(
	input 	wire 			rx_clk_90,
	input 	wire 			rst_n,
	input 	wire 	[3:0]	rx_dat,
	input 	wire			rx_ctrl,
	output 	wire 			rx_en,
	output 	wire 	[7:0]	rx_data
    );

reg 	[7:0]	rx_data_r;
reg 			rx_en_r;
wire 			rx_valid;
wire 	[7:0]	rxd;

assign rx_en = rx_en_r;
assign rx_data = rx_data_r;

always @(posedge rx_clk_90) 
begin
	if (rst_n == 1'b0) 
	begin
		rx_en_r <= 1'b0;	
		rx_data_r <= 'd0;	
	end	
	else 
	begin
		rx_en_r <= rx_valid;	
		rx_data_r <= rxd;	
	end
end

IDDR #(
.DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
// or "SAME_EDGE_PIPELINED"
.INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
.INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
.SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
) IDDR_inst_0 (
.Q1(rxd[0]), // 1-bit output for positive edge of clock
.Q2(rxd[4]), // 1-bit output for negative edge of clock
.C(rx_clk_90), // 1-bit clock input
.CE(1'b1), // 1-bit clock enable input
.D(rx_dat[0]), // 1-bit DDR data input
.R(~rst_n), // 1-bit reset
.S(1'b0) // 1-bit set
);

IDDR #(
.DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
// or "SAME_EDGE_PIPELINED"
.INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
.INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
.SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
) IDDR_inst_1 (
.Q1(rxd[1]), // 1-bit output for positive edge of clock
.Q2(rxd[5]), // 1-bit output for negative edge of clock
.C(rx_clk_90), // 1-bit clock input
.CE(1'b1), // 1-bit clock enable input
.D(rx_dat[1]), // 1-bit DDR data input
.R(~rst_n), // 1-bit reset
.S(1'b0) // 1-bit set
);

IDDR #(
.DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
// or "SAME_EDGE_PIPELINED"
.INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
.INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
.SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
) IDDR_inst_2 (
.Q1(rxd[2]), // 1-bit output for positive edge of clock
.Q2(rxd[6]), // 1-bit output for negative edge of clock
.C(rx_clk_90), // 1-bit clock input
.CE(1'b1), // 1-bit clock enable input
.D(rx_dat[2]), // 1-bit DDR data input
.R(~rst_n), // 1-bit reset
.S(1'b0) // 1-bit set
);

IDDR #(
.DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
// or "SAME_EDGE_PIPELINED"
.INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
.INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
.SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
) IDDR_inst_3 (
.Q1(rxd[3]), // 1-bit output for positive edge of clock
.Q2(rxd[7]), // 1-bit output for negative edge of clock
.C(rx_clk_90), // 1-bit clock input
.CE(1'b1), // 1-bit clock enable input
.D(rx_dat[3]), // 1-bit DDR data input
.R(~rst_n), // 1-bit reset
.S(1'b0) // 1-bit set
);

IDDR #(
.DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
// or "SAME_EDGE_PIPELINED"
.INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
.INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
.SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
) IDDR_inst_4 (
.Q1(rx_valid), // 1-bit output for positive edge of clock
.Q2(), // 1-bit output for negative edge of clock
.C(rx_clk_90), // 1-bit clock input
.CE(1'b1), // 1-bit clock enable input
.D(rx_ctrl), // 1-bit DDR data input
.R(~rst_n), // 1-bit reset
.S(1'b0) // 1-bit set
);

endmodule
