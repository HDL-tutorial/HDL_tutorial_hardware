`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/04/16 04:21:04
// Design Name: 
// Module Name: three_line_buffer
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


module three_line_buffer(
	input clk,
	input srst,
	input [31:0] din,
	input wr_en,
	input rd_en,
	output [31:0] duo,
	output [31:0] dco,
	output [31:0] dlo,
	output full,
	output empty
);

// Wires
wire ce;

wire [31:0] _uout;
wire _uwren;
wire _urden;
wire _uempty;
wire [31:0] uout;
wire uempty;

wire [31:0] _cout;
wire _cwren;
wire _crden;
wire _cempty;
wire [31:0] cout;
wire cempty;

wire [31:0] _lout;
wire _lwren;
wire _lrden;
wire _lempty;
wire [31:0] lout;
wire lempty;

wire [95:0] oin;
wire [95:0] oout;
wire owren;
wire ofull;
wire _owren;

// Regs
reg oe;     // Output Enable
reg uoe;    // Upper line Output Enable
reg coe;    // Center line Output Enable
reg loe;    // Lower line Output Enable

// Instantiations
fifo_fwft_32x4096 fifo_upper (
	.clk(clk),      // input wire clk
	.srst(srst),    // input wire srst
	.din(_cout),      // input wire [31 : 0] din
	.wr_en(_uwren),  // input wire wr_en
	.rd_en(_urden),  // input wire rd_en
	.dout(_uout),    // output wire [31 : 0] dout
	.full(),    // output wire full
	.empty(_uempty)  // output wire empty
);

fifo_fwft_32x4096 fifo_center (
	.clk(clk),      // input wire clk
	.srst(srst),    // input wire srst
	.din(_lout),      // input wire [31 : 0] din
	.wr_en(_cwren),  // input wire wr_en
	.rd_en(_crden),  // input wire rd_en
	.dout(_cout),    // output wire [31 : 0] dout
	.full(),    // output wire full
	.empty(_cempty)  // output wire empty
);

fifo_fwft_32x16 fifo_lower (
	.clk(clk),      // input wire clk
	.srst(srst),    // input wire srst
	.din(din),      // input wire [31 : 0] din
	.wr_en(_lwren),  // input wire wr_en
	.rd_en(_lrden),  // input wire rd_en
	.dout(_lout),    // output wire [31 : 0] dout
	.full(full),    // output wire full
	.empty(_lempty)  // output wire empty
);

fifo_fwft_96x16 fifo_interface (
	.clk(clk),      // input wire clk
	.srst(srst),    // input wire srst
	.din(oin),      // input wire [95 : 0] din
	.wr_en(owren),  // input wire wr_en
	.rd_en(rd_en),  // input wire rd_en
	.dout(oout),    // output wire [95 : 0] dout
	.full(ofull),    // output wire full
	.empty(empty)  // output wire empty
);

// Assignment
assign ce = !ofull;
assign uempty = _uempty & uoe;
assign cempty = _cempty & coe;
assign lempty = _lempty & loe;
assign _owren = !(uempty | cempty | lempty | ofull);
assign _uwren = _crden;
assign _cwren = _lrden;
assign _lwren = wr_en;
assign _urden = _owren & uoe;
assign _crden = _owren & coe;
assign _lrden = _owren;
assign uout = select(_uout, uoe);
assign cout = select(_cout, coe);
assign lout = select(_lout, loe);
assign oin = {uout, cout, lout};
assign owren = _owren & oe;
assign duo = oout[95:64];
assign dco = oout[63:32];
assign dlo = oout[31:0];

// Functions
function [31:0] select;
	input [31:0] data;
	input s;
	begin
		if(s == 1'b0)
		begin
			select = 32'h00_00_00_00;
		end
		else
		begin
			select = data;
		end
	end
endfunction

// Behavior
always@(posedge clk)
begin
	if(srst)
	begin
		oe <= 1'b0;
		uoe <= 1'b0;
		coe <= 1'b0;
		loe <= 1'b1;
	end
	else if(ce)
	begin
		if(oe == 1'b0 && uoe == 1'b0 && coe == 1'b0 && loe == 1'b1 && _lout[24] == 1'b1)
		begin
			oe <= 1'b1;
			uoe <= 1'b0;
			coe <= 1'b1;
			loe <= 1'b1;
		end
		else if(oe == 1'b1 && uoe == 1'b0 && coe == 1'b1 && loe == 1'b1 && _cout[24] == 1'b1)
		begin
			oe <= 1'b1;
			uoe <= 1'b1;
			coe <= 1'b1;
			loe <= 1'b1;
		end
	end
end

endmodule
