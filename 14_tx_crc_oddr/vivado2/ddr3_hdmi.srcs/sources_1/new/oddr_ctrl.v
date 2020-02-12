// -----------------------------------------------------------------------------
// Copyright (c) 2014-2019 All rights reserved
// -----------------------------------------------------------------------------
// Author : Youkaiyuan  v3eduyky@126.com
// wechat : 15921999232
// File   : oddr_ctrl.v
// Create : 2019-11-05 19:26:50
// Revise : 2019-11-05 19:27:23
// Editor : sublime text3, tab size (2)
// -----------------------------------------------------------------------------

module	oddr_ctrl(
	input	wire		sclk,
	input	wire	[7:0]	tx_dat,	
	input	wire		tx_en,
	input	wire		tx_c,//œ‡“∆ ±÷”
	
	output	wire	[3:0]	tx_data,
	output	wire		tx_dv,
	output	wire		tx_clk
);
ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) ODDR_DV_inst (
      .Q(tx_dv),   // 1-bit DDR output
      .C(sclk),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(tx_en), // 1-bit data input (positive edge)
      .D2(tx_en), // 1-bit data input (negative edge)
     .R(1'b0),  // 1-bit reset
     .S(1'b0)    // 1-bit set
   );	
 ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) ODDR_CLK_inst (
      .Q(tx_clk),   // 1-bit DDR output
      .C(sclk),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(1'b1), // 1-bit data input (positive edge)
      .D2(1'b0), // 1-bit data input (negative edge)
     .R(1'b0),  // 1-bit reset
     .S(1'b0)    // 1-bit set
   );	   
 genvar j;
generate
	for(j=0;j<4;j=j+1)
		begin
ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC" 
) ODDR_DATA_inst (
      .Q(tx_data[j]),   // 1-bit DDR output
      .C(sclk),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(tx_dat[j]), // 1-bit data input (positive edge)
      .D2(tx_dat[j+4]), // 1-bit data input (negative edge)
     .R(1'b0),  // 1-bit reset
     .S(1'b0)    // 1-bit set
   );	
end 
endgenerate 
endmodule