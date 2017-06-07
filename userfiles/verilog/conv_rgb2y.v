`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/05 20:29:21
// Design Name: 
// Module Name: conv_rgb2y
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module conv_rgb2y(
	input clk,
	input srst,
	input [31:0] din,
	input wr_en,
	input rd_en,
	output [31:0] dout,
	output full,
	output empty
);

/// Wires
wire ce;

wire [7:0] r;
wire [7:0] g;
wire [7:0] b;

wire [14:0] r77;
wire [15:0] g150;
wire [12:0] b29;

wire [15:0] sum;
wire [7:0] y;

/// Registers
reg [15:0] sumRG;
reg [12:0] sh_b29;

reg sh_wren1;
reg sh_wren2;

/// Assignments
assign ce = !full;
assign r = din[23:16];
assign g = din[15:8];
assign b = din[7:0];
assign sum = sumRG + sh_b29;
assign y = sum[15:8];

/// Instantiations
mult_77 mul_r (
	.CLK(clk),  // input wire CLK
	.A(r),      // input wire [7 : 0] A
	.CE(ce),    // input wire CE
	.P(r77)      // output wire [14 : 0] P
);

mult_150 mul_g (
	.CLK(clk),  // input wire CLK
	.A(g),      // input wire [7 : 0] A
	.CE(ce),    // input wire CE
	.P(g150)      // output wire [15 : 0] P
);

mult_29 mul_b (
	.CLK(clk),  // input wire CLK
	.A(b),      // input wire [7 : 0] A
	.CE(ce),    // input wire CE
	.P(b29)      // output wire [12 : 0] P
);

fifo_fwft_32x16 fifo_interface (
	.clk(clk),
	.srst(srst),
	.din({24'h000000, y}),
	.wr_en(sh_wren2),
	.rd_en(rd_en),
	.dout(dout),
	.full(full),
	.empty(empty)
);

/// Behavior
always@(posedge clk)
begin
	if(srst)
	begin
		sumRG <= 16'h0;
		sh_b29 <= 13'h0;

		sh_wren1 <= 1'b0;
		sh_wren2 <= 1'b0;
	end
	else if(ce)
	begin
		sumRG <= r77 + g150;
		sh_b29 <= b29;

		sh_wren1 <= wr_en;
		sh_wren2 <= sh_wren1;
	end
end

endmodule
