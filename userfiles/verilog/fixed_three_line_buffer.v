`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/09 21:49:35
// Design Name: 
// Module Name: fixed_three_line_buffer
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


module fixed_three_line_buffer(
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
wire wren;
wire [7:0] ctrl;

wire [31:0] data;

// Assignments
assign wren = wr_en & !(din[31] | din[30]);
assign data = {ctrl, din[23:0]};

// Instantiations
control_generator ctrl_gen(
   .CLK(clk),
   .CE(wren),
   .SRST(srst),
   .L_W_THRESH0(din[25:15]),
   .LOAD_W_THRESH0(din[31]),
   .L_H_THRESH0(din[10:0]),
   .LOAD_H_THRESH0(din[30]),
   .CONTROL(ctrl)
);

three_line_buffer lb3(
   .clk(clk),
   .srst(srst),
   .din(data),
   .wr_en(wren),
   .rd_en(rd_en),
   .duo(duo),
   .dco(dco),
   .dlo(dlo),
   .full(full),
   .empty(empty)
);

endmodule
