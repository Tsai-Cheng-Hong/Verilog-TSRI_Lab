/********************************************************************
 * Model of RAM Memory - Verilog Training Course.
 *********************************************************************/

`timescale 1ns / 1ns

module mem(data,addr,read,write);
  inout [7:0] data;
  input [4:0] addr;
  input       read, write;

  reg [7:0] memory [0:31];

  assign data = (read ? memory[addr] : 8'bz);

  always @(posedge write)
    memory[addr] = data;

endmodule
