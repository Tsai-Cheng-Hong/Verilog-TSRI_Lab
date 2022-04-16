module mux_test;

// Signal declaration
	reg a, b, sel;

// MUX instance
	mux mux (out, a, b, sel);

// Apply Stimulus

initial
begin
  // ** Add stimulus here **
  #10 a = 0; b = 0; sel = 0;
  #10 a = 1;
  #10 a = 0;        sel = 1;
  #10        b = 1; 
  #10 $finish;
  // ** Add stimulus here **
end


// Display Results
 
initial  // print all changes to all signal values
  $monitor($time, "  a = %b,  b = %b,  sel = %b,   out = %b", a,b,sel,out);

//  Waveform Record  
initial
begin
    $fsdbDumpfile("mux.fsdb"); // The FSDB Database
    $fsdbDumpvars;

    $shm_open("mux.shm");  // The SHM Database
    $shm_probe("AC");
    
    $dumpfile("mux.vcd");   // The VCD Database
    $dumpvars;

end



endmodule
