module alu(alu_out, accum, data, opcode, zero, clk, reset);
input clk, reset;
input [7:0] accum, data;
input [2:0] opcode;
output [7:0] alu_out;
output zero;
reg [7:0] alu_out;

always@(posedge clk)
begin
  if (reset)  begin
	alu_out = 0;
  end
  else   begin
	case (opcode)
		3'b000 :  alu_out = accum;
		3'b001 :  alu_out = (accum + data);
		3'b010 :  alu_out = (accum - data);
		3'b011 :  alu_out = (accum & data);
		3'b100 :  alu_out = (accum ^ data);
		3'b101 :  alu_out = (accum[7]==0)? accum : ((~accum)+8'b1);
		3'b110 :  alu_out = ~accum + 8'b1;
		3'b111 :  alu_out = data;
		default :  alu_out = 8'b0;
	endcase
  end
end

assign  zero = (accum == 8'b0)? 1'b1 : 0;

endmodule
