`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/04/17 00:21:21
// Design Name: 
// Module Name: signal_generator
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


module fixed_signal_generator
#(
   parameter depth = 3,    // Frame size : 2^depth x 2^depth
   parameter frame = 1,    // The number of the output frames
   parameter interval = 0  // Interval between frames
)(
   input clk,
   input srst,
   input rd_en,
   output [31:0] dout,
   output empty
);

// Params
localparam frameSize = {depth{1'b1}};
localparam counterSize = (depth <= 8) ? 8 : depth;
localparam [7:0] counterMax = (depth <= 8) ? {{8-depth{1'b0}}, {depth{1'b1}}} : 8'hff;
localparam size = {{15-depth{1'b0}}, frameSize};
localparam initValue = {2'b11, size, size};

// Wires
wire ce;

wire [31:0] pixels;

// Regs
reg [counterSize-1:0] counterH;  // Horizontal counter
reg [counterSize-1:0] counterV;  // Vertical counter
reg [7:0] counterF;              // Frame counter
reg [7:0] counterI;              // Interval counter
reg epl;                         // the End of the Pixel of the Frame
reg elf;                         // the End of the Line of the Frame
reg init;
reg [31:0] data;

reg emp;
reg sh_emp;

// Assignments
assign ce = rd_en;

assign dout = data;
assign empty = sh_emp;

assign pixels = counterV * {1'b1, {depth{1'b0}}} + counterH + 1;

// Behavior
always@(posedge clk)
begin
   if(srst)
   begin
      counterH <= 8'h00;
      counterV <= 8'h00;
      counterF <= 4'h0;
      counterI <= interval;
      epl <= 1'b0;
      elf <= 1'b0;
      emp <= 1'b1;
      sh_emp <= 1'b1;
      init <= 1'b0;
      data <= 0;
   end
   else if(ce)
   begin
      if(counterF != frame)
      begin
         if(!emp)
         begin
            if(counterH == frameSize)
            begin
               counterH <= 8'h00;
               counterV <= counterV + 1;

               if(counterV == frameSize-1)
               begin
                  elf <= 1'b1;
               end
               else
               begin
                  elf <= 1'b0;
               end
            end
            else
            begin
               counterH <= counterH + 1;
            end

            if(counterH == frameSize-1)
            begin
               epl <= 1'b1;
            end
            else
            begin
               epl <= 1'b0;
            end

            if(counterV == frameSize && counterH == frameSize)
            begin
               counterH <= 8'b00;
               counterV <= 8'b00;
               counterF <= counterF + 1;
               counterI <= 4'h0;

               if(interval > 0)
               begin
                  emp <= 1'b1;
               end
            end
         end
         else
         begin
            if(counterI >= interval - 1 || interval == 0)
            begin
               emp <= 1'b0;
            end
            else
            begin
               counterI <= counterI + 1;
            end 
         end
      end

      if(!init)
      begin
         data <= initValue;
         init <= 1'b1;
         sh_emp <= 1'b0;
      end
      else
      begin
         //data <= {counterF[3:0], 2'b00, elf, epl, 8'h00, counterV[7:0], counterMax - counterH[7:0]};
         data <= {counterF[3:0], 2'b00, elf, epl, pixels[7:0], pixels[7:0], pixels[7:0]};
         sh_emp <= emp;
      end
   end
end

endmodule
