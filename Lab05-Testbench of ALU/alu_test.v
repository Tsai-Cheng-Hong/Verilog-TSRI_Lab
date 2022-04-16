/*********************************************************************
 * Stimulus for the ALU design - Verilog Training Course
 *********************************************************************/
`timescale 1ns / 1ns
module alu_test;
  wire [7:0] alu_out;
  reg  [7:0] data, accum;
  reg  [2:0] opcode;
  integer    i, err_cnt, k;
  wire [7:0] twocomp_accum;
  wire [7:0] abs_accum;
  reg clk, reset;
  
  parameter ranseed = 7;
  
// Instantiate the ALU.  Named mapping allows the designer to have freedom
//    with the order of port declarations

  alu   alu1 (.alu_out(alu_out), .zero(zero),               //outputs from ALU
	      .opcode(opcode), .data(data), .accum(accum), .clk(clk), .reset(reset)); //inputs to ALU

  //define mnemonics to represent opcodes
  `define PASSA 3'b000
  `define ADD   3'b001
  `define SUB   3'b010
  `define AND   3'b011
  `define XOR   3'b100
  `define ABS   3'b101
  `define NEG   3'b110
  `define PASSD 3'b111

// Define a safe delay between each strobing of the ALU inputs/outputs
  `define strobe      20
  `define testnumber  10
assign  twocomp_accum = ~accum + 8'b1;

assign  abs_accum = (accum[7])? twocomp_accum : accum;

// clock generate
initial   clk = 0;
always #(`strobe/2) clk = ~clk;

// pattern generate
  initial
    begin
    
       // SET UP THE GRAPHICAL WAVEFORM DISPLAY
      $shm_open("alu.shm");
      $shm_probe(alu_out,data,accum,opcode,zero);
      $fsdbDumpfile("alu.fsdb");
      $fsdbDumpvars();
      
      // SET UP THE OUTPUT FORMAT FOR THE TEXT DISPLAY
      $display("\t\t\t            INPUTS                   EXPECTD OUTPUTS       REAL    OUTPUT  \n");
      $display("\t\t\t  OPCODE   DATA IN    ACCUM IN  |  ALU OUT   ZERO BIT |  ALU OUT   ZERO BIT");
      $display("\t\t\t  ------   --------   --------  |  --------  -------- |  --------  --------");
      $timeformat(-9, 1, " ns", 9); //Display time in nanoseconds
      err_cnt = 0;   
      reset = 0;
      
      # `strobe;
      accum = 8'h37;
      data = 8'hD6;
      reset = 1;
      $display ("initial test, reset enable, alu_out = %b", alu_out);
      
      # `strobe;
        reset = 0;
	for (k = 0; k <= `testnumber; k = k+1)
	begin      
      		for (i = 0; i <= 7; i = i+1)  //VERIFY OPERATION FOR ALL 8 OPCODES
        		begin
			@(negedge clk)
			//change inputs at strobe point
          		#(`strobe/4) opcode = i;
			// APPLY STIMULUS TO THE INPUT PINS
			accum = $random % ranseed;                //Initialize inputs to the ALU
      			data = $random % ranseed;
          		//Wait for ALU to process inputs
          		#(`strobe/2)   check_outputs; //call a task to verify outputs
        		end
		
      		//VERIFY OPERATION WITH UNKNOWN OPCODE
      		@(negedge clk)  #(`strobe/4)  opcode = 3'b00x;
      		#(`strobe/2)   check_outputs;

      		//VERIFY OPERATION OF ZERO BIT
     		@(negedge clk) #(`strobe/4) accum = 8'h00; opcode = `ADD;
      		#(`strobe/2)   check_outputs;
		
	end
	
      //WAIT 1 MORE STROBE AND THEN FINISH
      #`strobe 
      if (err_cnt) $display("\nThere were %d errors in all.\n", err_cnt);
      else $display("\nNo errors were found!\n");
      $finish;
    end

/**********************************************************************
 * SUBROUTINES TO COMPARE THE ALU OUTPUTS TO EXPECTED RESULTS
 *********************************************************************/
  task check_outputs;
    casez (opcode)
       `PASSA  : begin
                  $display("PASS ACCUM OPERATION:",
                           "      %b     %b   %b  |  %b      %b    |  %b      %b",
                           opcode, data, accum, accum, !accum, alu_out, zero);
                  if ((alu_out !== accum) || (zero !== !accum)) error;
                 end
       `ADD    : begin
                   $display("ADD OPERATION       :",
                            "      %b     %b   %b  |  %b      %b    |  %b      %b",
                            opcode, data, accum, (accum+data), !accum, alu_out, zero);
                   if ((alu_out !== (accum + data)) || (zero !== !accum)) error;
                 end
       `SUB    : begin
                   $display("SUB OPERATION       :",
                            "      %b     %b   %b  |  %b      %b    |  %b      %b",
                            opcode, data, accum, (accum-data), !accum, alu_out, zero);
                   if ((alu_out !== (accum - data)) || (zero !== !accum)) error;
                 end
       `AND    : begin
                   $display("AND OPERATION       :",
                            "      %b     %b   %b  |  %b      %b    |  %b      %b",
                            opcode, data, accum, (accum&data), !accum, alu_out, zero);
                   if ((alu_out !== (accum & data)) || (zero !== !accum)) error;
                 end
        `XOR   : begin
                   $display("XOR OPERATION       :",
                           "      %b     %b   %b  |  %b      %b    |  %b      %b",
                           opcode, data, accum, (accum^data), !accum, alu_out, zero);
                   if ((alu_out !== (accum ^ data)) || (zero !== !accum)) error;
                 end
	`ABS    : begin
                   $display("ABS OPERATION       :",
                            "      %b     %b   %b  |  %b      %b    |  %b      %b",
                            opcode, data, accum, abs_accum, !accum, alu_out, zero);
                   if ((alu_out !== abs_accum) || (zero !== !accum)) error;
                 end
	`NEG    : begin
                   $display("NEG OPERATION       :",
                            "      %b     %b   %b  |  %b      %b    |  %b      %b",
                            opcode, data, accum, twocomp_accum, !accum, alu_out, zero);
                   if ((alu_out !== twocomp_accum) || (zero !== !accum)) error;
                 end
       `PASSD  : begin
                   $display("PASS DATA OPERATION :",
                            "      %b     %b   %b  |  %b      %b    |  %b      %b",
                            opcode, data, accum, data, !accum, alu_out, zero);
                   if ((alu_out !== data) || (zero !== !accum)) error;
                 end
       default : begin
                   $display("UNKNOWN OPERATION   :",
                            "      %b     %b   %b  |  %b      %b    |  %b      %b",
                            opcode, data, accum, 8'b0, !accum,alu_out, zero);
                   if ((alu_out !== 8'b0) || (zero !== !accum)) error;
                 end
    endcase
  endtask

  task error;
    begin
      $display("\t\t\t ERROR AT %t,  ERROR OUTPUT : ALU_OUT = %b, ZERO_BIT = %b\n",
               $realtime, alu_out, zero);
      err_cnt = err_cnt + 1;
    end
  endtask

endmodule
