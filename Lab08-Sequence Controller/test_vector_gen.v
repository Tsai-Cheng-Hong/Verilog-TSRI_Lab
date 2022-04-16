/*****************************************************************************
 * Procedural stimulus to test the Sequence Controller - 
 * Verilog Training Course
 *
 * This module contains the following parts:
 *
 * 1. A routine which provides procedural stimulus to the inputs of the
 *    controller design.
 *
 * 2. A routine to generate a test vector file by recording the stimulus.
 *
 * 3. A routine to generate an expected results file based on the outputs
 *    of the controller design.
 ****************************************************************************/

`timescale 1ns / 1ns
module test_vector_generator;

  `define period         10
  `define setup_time     2
  `define fetch_cycle    80
  `define prop_delay     5 /* time for changes on inputs to reach outputs */
   
  `define outs rd,wr,ld_ir,ld_acc,ld_pc,inc_pc,halt,data_e,sel
  
  reg [2:0] opcode;
  reg       rst, zero, clk;

  integer    vector_file ;

  control i1(`outs, opcode, zero, clk, rst);

/*****************************************************************************
 * Generate the clock
 ****************************************************************************/
  initial
    begin
      clk=1;
      forever #(`period/2) clk = !clk; 
    end

  initial                 //CREATE INPUT STIMULUS WITH PROCEDURAL STATEMENTS
    begin
      $timeformat(-9, 1, " ns", 9);   //display time in nanoseconds
//reset the system
      {zero, opcode, rst} = 0;
   
//test all instructions except halt with zero bit = 0
      #(`fetch_cycle - `setup_time - 10)
      rst = 1;
      for (opcode = 1; opcode < 7; opcode = opcode + 1) 
        #`fetch_cycle ;  //change opcode just  before fetch
      opcode = 7; #`fetch_cycle 
//test all instructions except halt with zero bit = 1
      zero = 1;
      for (opcode = 1; opcode < 7; opcode = opcode + 1)    
        #`fetch_cycle ;  //change opcode just before fetch
      opcode = 7; #`fetch_cycle 
    
//test halt instruction
      opcode = 0; #`fetch_cycle

      $display("\n*** Completed generating new pattern files. ***\n");
      $finish;
    end

  initial                 //WRITE INPUT STUMULUS TO TEST VECTOR FILE
    begin
      $display("\n*** Generating test vector file ",
               "\"test_vectors.pat\"...");

      vector_file = $fopen("test_vectors.pat");
      $fdisplay(vector_file,"//TEST VECTORS FOR TESTING THE SEQUENCE CONTROLLER");
      $fdisplay(vector_file,"//");
      $fdisplay(vector_file,"//THE VECTOR ORDER IS:  rst  zero_bit  opcode");
      $fdisplay(vector_file,"//");

      //write first pattern to file at end of time 0
      $fstrobe(vector_file,"%b_%b_%b", rst, zero, opcode);
      forever #`fetch_cycle   //write input pattern to file at every fetch
       $fstrobe(vector_file,"%b_%b_%b", rst, zero, opcode);
    end

/*****************************************************************************
 * Block to generate a new file of expected results based on the current test
 * pattern file and decoder model.
 ****************************************************************************/
  initial
    begin : gen_results
    integer result_file;
      $display("\n*** Generating a new expected results file...");

      result_file = $fopen("expected_results.pat");
      $fdisplay(result_file,"//EXPECTED RESULT PATTERNS FOR TESTING THE ",
                        "VeriRisc SEQUENCE CONTROLLER");
      $fdisplay(result_file,"//");
      $fdisplay(result_file,"//THE PATTERN ORDER IS: rd  wr  ld_ir  ld_acc  ",
		"ld_pc  inc_pc  halt  data_e  sel");
      $fdisplay(result_file,"//");
      wait (opcode)
      forever @(posedge clk)
        #`prop_delay $fstrobe(result_file, `outs);
    end

endmodule
