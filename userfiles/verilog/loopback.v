`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/12 21:03:02
// Design Name: 
// Module Name: loopback
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


module loopback(
	input clk,
	input srst,
	input [31:0] din,
	input wr_en,
	input rd_en,
	output [31:0] dout,
	output full,
	output empty
);

wire ce = !full;

reg [31:0] sh_din1;
reg [31:0] sh_din2;

reg sh_wren1;
reg sh_wren2;

fifo_fwft_32x16 fifo_interface (
	.clk(clk),      // input wire clk
	.srst(srst),    // input wire srst
	.din(sh_din2),      // input wire [31 : 0] din
	.wr_en(sh_wren2),  // input wire wr_en
	.rd_en(rd_en),  // input wire rd_en
	.dout(dout),    // output wire [31 : 0] dout
	.full(full),    // output wire full
	.empty(empty)  // output wire empty
);

always@(posedge clk)
begin
	if(srst)
	begin
		sh_din1 <= 32'd0;
		sh_din2 <= 32'd0;

		sh_wren1 <= 1'b0;
		sh_wren2 <= 1'b0;
	end
	else if(ce)
	begin
		sh_din1 <= din;
		sh_din2 <= sh_din1;

		sh_wren1 <= wr_en;
		sh_wren2 <= sh_wren1;
	end
end

endmodule
