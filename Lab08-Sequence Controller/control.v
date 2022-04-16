/*****************************************************************************
 * This is an Explicit State Machine model of the Sequence Contoller - 
 * Verilog Training Course ("VeriRisc CPU" lab).
 * 
 * This model uses sequential logic (a state counter) to generate the 
 * control lines used in the VeriRisc CPU design. 
 ****************************************************************************/

`timescale 1ns / 1ns
module control(rd, wr, ld_ir, ld_acc, ld_pc, inc_pc, halt, data_e, sel,
               opcode, zero, clk, rst);

  output       rd, wr, ld_ir, ld_acc, ld_pc, inc_pc, halt, data_e, sel;
  input [2:0]  opcode;
  input        zero, clk, rst;

  reg          rd, wr, ld_ir, ld_acc, ld_pc, inc_pc, halt, data_e, sel;

  reg  [2:0]   state; // state variable, necessary in explicit machines

  `define  HLT  3'b000
  `define  SKZ  3'b001
  `define  ADD  3'b010
  `define  AND  3'b011
  `define  XOR  3'b100
  `define  LDA  3'b101
  `define  STO  3'b110
  `define  JMP  3'b111

  `define outputs {rd,wr,ld_ir,ld_acc,ld_pc,inc_pc,halt,data_e, sel}
  `define LOG ((opcode == `ADD) || (opcode == `AND) || (opcode == `XOR) || (opcode == `LDA))

  always @(posedge clk or negedge rst)
    if (!rst)
      {`outputs, state} <= 0;
    else
      begin
        case (state)
          3'b000 : `outputs <= 9'b000000001;      // instruction fetch setup
          3'b001 : `outputs <= 9'b100000001;      // instruction fetch
          3'b010 : `outputs <= 9'b101000001;      // instruction load
          3'b011 : `outputs <= 9'b101000001;      // idle
          3'b100 : if (opcode == `HLT) `outputs = 9'b000001100;
		   else `outputs <= 9'b000001000; // data fetch setup
          // set mem_rd if opcode = ADD,AND,XOR,LDA (a binary operation)
          3'b101 : if `LOG `outputs <= 9'b100000000;
		   else `outputs <= 9'b000000000; // operand fetch
          3'b110 : instruction_operation;       // instruction operation
          3'b111 : store_result;                // store result
        endcase
	state <= state + 1'b1;
      end

  task instruction_operation;     //state 6
      case (opcode)
      `SKZ :         if (zero) `outputs <= 9'b000001010;
		          else `outputs <= 9'b000000010;
      `ADD, `AND, `XOR, `LDA : `outputs <= 9'b100000000; 
      `JMP :                   `outputs <= 9'b000010010;
      default :                `outputs <= 9'b000000010;
      endcase
  endtask

  task store_result;              //state 7
      case (opcode)
      `SKZ :         if (zero) `outputs <= 9'b000001010;
		          else `outputs <= 9'b000000010;
      `ADD, `AND, `XOR, `LDA : `outputs <= 9'b100100000;
      `STO :                   `outputs <= 9'b010000010;
      `JMP :                   `outputs <= 9'b000011010;
      default: 		       `outputs <= 9'b000000010;
      endcase
  endtask
endmodule

