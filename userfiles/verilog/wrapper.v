`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/05 21:52:42
// Design Name: 
// Module Name: wrapper
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


module wrapper(
	input clk,
	input srst,
	input [31:0] din,
	input wr_en,
	input rd_en,
	output [31:0] dout,
	output full,
	output empty
);

wire rgb2y_rden;
wire [31:0] rgb2y_dout;
wire rgb2y_full;
wire rgb2y_empty;

wire fifo_sh_rden;
wire [31:0] fifo_sh_dout;
wire fifo_sh_full;
wire fifo_sh_empty;

wire [31:0] lb_din;
wire lb_wren;
wire lb_rden;
wire [31:0] lb_duo;
wire [31:0] lb_dco;
wire [31:0] lb_dlo;
wire lb_full;
wire lb_empty;

wire filter_wren;
wire filter_rden;
wire [31:0] filter_dout;
wire filter_full;
wire filter_empty;

wire fifo_wren;
wire fifo_full;

assign full = rgb2y_full | fifo_sh_full;

assign rgb2y_rden = !(rgb2y_empty | fifo_sh_empty | lb_full);
assign fifo_sh_rden = !(rgb2y_empty | fifo_sh_empty | lb_full);
assign lb_wren = !(rgb2y_empty | fifo_sh_empty | lb_full);
assign lb_rden = !(lb_empty | filter_full);
assign filter_wren = !(lb_empty | filter_full);
assign filter_rden = !(filter_empty | fifo_full);
assign fifo_wren = !(filter_empty | fifo_full);

assign lb_din = (fifo_sh_dout[31:30] == 2'b11) ? fifo_sh_dout : rgb2y_dout;

conv_rgb2y rgb2y(
	.clk(clk),
	.srst(srst),
	.din(din),
	.wr_en(wr_en),
	.rd_en(rgb2y_rden),
	.dout(rgb2y_dout),
	.full(rgb2y_full),
	.empty(rgb2y_empty)
);

fifo_fwft_32x16 fifo_shift(
	.clk(clk),
	.srst(srst),
	.din(din),
	.wr_en(wr_en),
	.rd_en(fifo_sh_rden),
	.dout(fifo_sh_dout),
	.full(fifo_sh_full),
	.empty(fifo_sh_empty)
);

fixed_three_line_buffer line_buf(
	.clk(clk),
	.srst(srst),
	.din(lb_din),
	.wr_en(lb_wren),
	.rd_en(lb_rden),
	.duo(lb_duo),
	.dco(lb_dco),
	.dlo(lb_dlo),
	.full(lb_full),
	.empty(lb_empty)
);

gaussian gauss(
	.clk(clk),
	.srst(srst),
	.dui(lb_duo[7:0]),
	.dci(lb_dco[7:0]),
	.dli(lb_dlo[7:0]),
	.wr_en(filter_wren),
	.rd_en(filter_rden),
	.dout(filter_dout),
	.full(filter_full),
	.empty(filter_empty)
);

fifo_32x512 fifo_32(
	.clk(clk),
	.srst(srst),
	.din(filter_dout),
	.wr_en(fifo_wren),
	.rd_en(rd_en),
	.dout(dout),
	.full(fifo_full),
	.empty(empty)
);


endmodule
