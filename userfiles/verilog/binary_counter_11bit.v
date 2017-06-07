`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/09 17:26:24
// Design Name: 
// Module Name: binary_counter_11bit
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

module binary_counter_11bit(
   input CLK,
   input CE,
   input SINIT,
   input [10:0] L_THRESH0,
   input LOAD_THRESH0,
   output [10:0] Q,
   output THRESH0
);

// Wires
wire [10:0] count;

// Registers
reg [10:0] THRESH0_VALUE = 11'h7ff;

// Assignments
assign Q = count;
assign THRESH0 = (count == THRESH0_VALUE);

// Instantiation
c_counter_binary_11bit counter (
   .CLK(CLK),      // input wire CLK
   .CE(CE),        // input wire CE
   .LOAD(SINIT),   // input wire LOAD
   .L(11'd0),      // input wire [10 : 0] L
   .Q(count)       // output wire [10 : 0] Q
);

always@(posedge CLK)
begin
   if(LOAD_THRESH0)
   begin
      THRESH0_VALUE <= L_THRESH0;
   end
end

endmodule
