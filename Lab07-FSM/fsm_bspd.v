// Serial Input BitStream Pattern Detector
module fsm_bspd(clk, reset, bit_in, det_out);
input clk, reset, bit_in;
output det_out;

reg det_out;
reg [2:0] C_STATE, N_STATE;

parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

always@(posedge clk)   // CS
begin
if (reset) C_STATE <= S0;
else	C_STATE <= N_STATE;
end

always@(C_STATE or bit_in)  // NS
begin
case ( C_STATE )
	S0 : N_STATE = (!bit_in) ? S1 : S0; 
	S1 : N_STATE = (!bit_in) ? S2 : S0;
	S2 : N_STATE = (!bit_in) ? S2 : S3;  
	S3 : N_STATE = (!bit_in) ? S1 : S0;
	default : N_STATE = S0;
endcase
end


always@(C_STATE or bit_in)  // Separate OL
begin
if ( (C_STATE==S3) && (bit_in==1'b0) ) det_out = 1;
else	det_out = 0;
end


endmodule

