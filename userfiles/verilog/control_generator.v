`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/09 18:21:16
// Design Name: 
// Module Name: control_generator
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


module control_generator(
   input CLK,
   input CE,
   input SRST,
   input [10:0] L_W_THRESH0,
   input LOAD_W_THRESH0,
   input [10:0] L_H_THRESH0,
   input LOAD_H_THRESH0,
   output [7:0] CONTROL
);

// Wires
wire w_th0;
wire h_th0;

// Registers

// Assignments
assign CONTROL = {6'b0000_00, h_th0, w_th0};

// Instantiations
binary_counter_11bit w_cnt(
   .CLK(CLK),
   .CE(SRST | LOAD_W_THRESH0 | CE),
   .SINIT(SRST | LOAD_W_THRESH0 | w_th0),
   .L_THRESH0(L_W_THRESH0),
   .LOAD_THRESH0(LOAD_W_THRESH0),
   .Q(),
   .THRESH0(w_th0)
);

binary_counter_11bit h_cnt(
   .CLK(CLK),
   .CE(SRST | LOAD_H_THRESH0 | (CE & w_th0)),
   .SINIT(SRST | LOAD_H_THRESH0 | (h_th0 & w_th0)),
   .L_THRESH0(L_H_THRESH0),
   .LOAD_THRESH0(LOAD_H_THRESH0),
   .Q(),
   .THRESH0(h_th0)
);

endmodule
