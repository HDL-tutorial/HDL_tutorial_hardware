`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/08 15:25:56
// Design Name: 
// Module Name: gaussian
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


module gaussian(
	input clk,
	input srst,
	input [7:0] dui,
	input [7:0] dci,
	input [7:0] dli,
	input wr_en,
	input rd_en,
	output [31:0] dout,
	output full,
	output empty
);

// Wires
wire ce = !full;
wire [11:0] sum;

// Registers
reg [8:0] sum_ul;
reg [8:0] dbl_c;

reg [9:0] sum_r;
reg [9:0] sum_m;
reg [9:0] sum_l;

reg [10:0] sum_rl;
reg [10:0] dbl_m;

reg wr_en1;
reg wr_en2;
reg wr_en3;
reg wr_en4;

reg first;

// Assignment
assign sum = sum_rl + dbl_m;

// Instantiations
fifo_fwft_32x16 fifo_interface (
	.clk(clk),      // input wire clk
	.srst(srst),    // input wire srst
	.din({8'h00, {3{sum[11:4]}}}),      // input wire [31 : 0] din
	.wr_en(wr_en4),  // input wire wr_en
	.rd_en(rd_en),  // input wire rd_en
	.dout(dout),    // output wire [31 : 0] dout
	.full(full),    // output wire full
	.empty(empty)  // output wire empty
);

// Behavior
always@(posedge clk)
begin
	if(srst)
	begin
		sum_ul <= 9'd0;
		dbl_c <= 9'd0;

		sum_r <= 10'd0;
		sum_m <= 10'd0;
		sum_l <= 10'd0;

		sum_rl <= 11'd0;
		dbl_m <= 11'd0;

		wr_en1 <= 1'b0;
		wr_en2 <= 1'b0;
		wr_en3 <= 1'b0;
		wr_en4 <= 1'b0;

		first <= 1'b1;
	end
	else if(ce)
	begin
		sum_ul <= dui + dli;
		dbl_c <= {dci, 1'b0};

		sum_r <= sum_ul + dbl_c;
		sum_m <= sum_r;
		sum_l <= sum_m;

		sum_rl <= sum_r + sum_l;
		dbl_m <= {sum_m, 1'b0};

		wr_en1 <= wr_en;
		wr_en2 <= wr_en1;
		wr_en3 <= wr_en2;
		wr_en4 <= first ? wr_en3 : wr_en2;

		if(wr_en3)
		begin
			first <= 1'b0;
		end
	end
end

endmodule
