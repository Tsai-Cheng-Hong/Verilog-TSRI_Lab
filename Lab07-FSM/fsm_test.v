//*****************************************************
// Testbench for the Serial Input Bitstream Pattern Detector
//*****************************************************

`timescale 1ns/10ps

module test_fsm;

`define CYCLE 10

reg clk;
reg reset, EN, bit_in;
reg answer;
integer count;
reg [3:0] cnt;
reg [4:0] shifter;
reg [9:0] data;
reg [31:0] cycle;

parameter [2:0] A0=3'b000, A1=3'b001,A2=3'b010,A3=3'b011,A4=3'b100;


//////////////////////////////////////////////////////
// DUT instance
//////////////////////////////////////////////////////
fsm_bspd i_fsm(.clk(clk), .reset(reset), .bit_in(bit_in), .det_out(det_out));


//////////////////////////////////////////////////////
// clock gen.
//////////////////////////////////////////////////////
initial clk = 0;
always #(`CYCLE/2 ) clk = ~clk;


//////////////////////////////////////////////////////
// initial setup & Finish flag
//////////////////////////////////////////////////////
initial
begin
	reset = 1'b1;
	EN = 1'b1;
	bit_in = 1'b0;
	answer = 1'b0;
	#13  reset = 1'b0;
	#4000
	$display("************************************************************"); 
	$display($time, ,"Finish testing with no error");
	$display("************************************************************"); 
	$finish;
end

//////////////////////////////////////////////////////
// stimulus gen.
//////////////////////////////////////////////////////

always@(posedge clk)
begin
if (reset) cnt <=  9;  // count the bit of data to be input
else  begin
	if (cnt == 0)  cnt <=  9;
	else cnt <=  cnt -1 ;
end
end


always@(posedge clk)
begin
if (reset) data <= 0;  
else if (cnt == 0) data <= data + 1;
else data <= data;
end




always@(posedge clk)
begin
if (reset) shifter <=   5'bxxxxx; // store value of data stream, used to generate golden pattern
else  begin
	shifter[4:1] <=  shifter [3:0];
	shifter[0] <=  data[cnt];
end
end

always@(posedge clk)
begin
if (reset) bit_in <=  0;
else bit_in <=  data[cnt];
end

always@(shifter or count)
begin
if (!shifter[3] && !shifter[2] && shifter[1] && !shifter[0])  answer = 1;
else answer = 0;
end



always@(posedge clk)
begin
if (reset) cycle <= 0;
else cycle <= cycle + 1;
#(`CYCLE/5) 
if (det_out == answer) begin
	
	end
else  begin
		$display($time,,"Testing failed at cycle %d !!, det_out should be %b", cycle, answer);
		#(`CYCLE * 2)
		$finish;
		end
end

//////////////////////////////////////////////////////
// Waveform DataBase.
//////////////////////////////////////////////////////
initial
begin
$fsdbDumpfile("fsm.fsdb");
$fsdbDumpvars();
end


endmodule
