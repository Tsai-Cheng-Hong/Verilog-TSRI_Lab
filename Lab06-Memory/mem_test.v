/**********************************************************************
 * Stimulus for the RAM model (fixed) - Verilog Training Course
 **********************************************************************/

`timescale 1ns / 1ns

module memtest;

  reg        read, write;
  reg  [4:0] addr;
  wire [7:0] data;
  reg  [7:0] expected;
  integer    error_cnt;

  reg  [7:0] data_reg;            //SHADOW REGISTER FOR PROCEDURAL ASSIGNMENTS

  assign data = (!read)?data_reg:8'bz;  //TRANSFER SHADOW REGISTER TO DATA BUS

  mem m1(data,addr,read,write);

  task write_val;
    begin
      #1 write = 1; // let address lines settle, then set write high
      #1 write = 0; // after 1ns, set write low
    end
  endtask

  task check_data;
    #1 if (data !== expected)        // Check data
       begin
	 $display("** ERROR at time %t! read back %h from address %h:",
		   $realtime, data, addr, "  Expected to read %h", expected);
	 error_cnt = error_cnt + 1;
       end
  endtask

  initial
    begin
      $shm_open ("mem.shm");
      $shm_probe (write,read,addr,data);
      $timeformat(-9, 1, " ns", 9);  //display time in nanoseconds

// Initialize all variables
      data_reg = 8'h0;               //ASSIGN VALUE TO SHADOW REGISTER
      error_cnt = 0; write = 0; read = 0; addr = 0;

// Initialize mem to all zeroes
      $display("\n   Setting all memory cells to zero...%t",$stime);
      repeat (32)
      begin
	write_val; 
	addr = addr + 1;	     // Step through all 32 memory locations
      end

// Read back a zero from memory
      $display("\n   Reading from one memory address...%t",$stime);
      #10 addr = 5'h0A;              // Read from the 10th word in memory
      read = 1;
      expected = 8'h00;		     // Data should be all zeroes
      check_data;
      #9 read  = 0;

// Set mem to alternating patterns
      $display("\n   Setting all memory cells to alternating patterns...%t",
		$stime);
      #10 addr = 0;
      data_reg = 8'hAA;              //ASSIGN VALUES TO SHADOW REGISTER
      repeat (32)
      begin
	write_val;
	addr = addr + 1;	     // Step through all 32 memory locations
	data_reg = ~data_reg;        //ASSIGN VALUES TO SHADOW REGISTER
      end

// Read back alternating patterns from five consecutive memory locations
      $display("\n   Doing block read from five memory addresses...%t",$stime);
      #10 expected = 8'h55;
      read = 1;
      for (addr = 5'h05; addr <= 5'h09; addr = addr + 1)
      begin
	check_data;
	expected = ~expected;	     // Alternate between checking for AA and 55
      end
      read = 0;
      $display("\n   Completed Memory Tests With %0d Errors!\n", error_cnt);

      $finish;
    end
 
endmodule
