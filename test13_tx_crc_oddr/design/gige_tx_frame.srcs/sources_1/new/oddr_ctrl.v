// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : sinply
// File   : oddr_ctrl.v
// Create : 2020-02-12 13:58:47
// Revise : 2020-02-12 19:01:08
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module oddr_ctrl(
	input 	wire 			tx_c,
	input 	wire 			rst,
	input 	wire 			tx_en,
	input 	wire 	[7:0]	tx_data,
	output 	wire 			tx_clk,
	output 	wire 			tx_ctrl,
	output 	wire 	[3:0]	tx_dat
    );

	ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) ODDR_inst_clk (
       .Q(tx_clk),   // 1-bit DDR output
       .C(tx_c),   // 1-bit clock input
       .CE(1'b1), // 1-bit clock enable input
       .D1(1'b1), // 1-bit data input (positive edge)
       .D2(1'b0), // 1-bit data input (negative edge)
       .R(rst),   // 1-bit reset
       .S(1'b0)    // 1-bit set
		);

	ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) ODDR_inst_ctrl (
       .Q(tx_ctrl),   // 1-bit DDR output
       .C(tx_c),   // 1-bit clock input
       .CE(1'b1), // 1-bit clock enable input
       .D1(tx_en), // 1-bit data input (positive edge)
       .D2(tx_en), // 1-bit data input (negative edge)
       .R(rst),   // 1-bit reset
       .S(1'b0)    // 1-bit set
		);

generate
	genvar i;
	for (i = 0; i < 4; i = i + 1)
	begin
		ODDR #(
	      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
	      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
	      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
	   ) ODDR_inst (
	       .Q(tx_dat[i]),   // 1-bit DDR output
	       .C(tx_c),   // 1-bit clock input
	       .CE(1'b1), // 1-bit clock enable input
	       .D1(tx_data[i]), // 1-bit data input (positive edge)
	       .D2(tx_data[i+4]), // 1-bit data input (negative edge)
	       .R(rst),   // 1-bit reset
	       .S(1'b0)    // 1-bit set
   		);
	end    
endgenerate

endmodule
