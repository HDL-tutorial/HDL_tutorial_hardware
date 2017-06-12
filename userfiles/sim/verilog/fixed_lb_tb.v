`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/04/17 00:16:01
// Design Name: 
// Module Name: top
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


module fixed_lb_tb;

reg clk;
reg srst;
reg rd_en;
reg ready;
reg [31:0] result;

wire sg_empty;

wire wr_en;
wire [31:0] din;
wire [31:0] dout;
wire full;
wire empty;

fixed_signal_generator
#(
	.depth(3),
	.frame(5),
	.interval(10)
) sg (
	.clk(clk),
	.srst(srst),
	.rd_en(!full),
	.dout(din),
	.empty(sg_empty)
);

assign wr_en = !(sg_empty | full);
wrapper wrapper(
	.clk(clk),
	.srst(srst),
	.din(din),
	.wr_en(wr_en),
	.rd_en(ready & !empty),
	.dout(dout),
	.full(full),
	.empty(empty)
);

localparam STEP = 10;
localparam DELAY = 100;

always
begin
	clk <= 1'b1;
	#(STEP / 2);
	clk <= 1'b0;
	#(STEP / 2);
end

always@(posedge clk)
begin
	rd_en <= ready & !empty;
	if(rd_en)
	begin
		result <= dout;
	end
end

initial
begin
	#DELAY;
	srst <= 1'b1;
	ready <= 1'b1;
	#STEP;
	srst <= 1'b0;
end
endmodule
