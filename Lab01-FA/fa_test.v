`timescale  1ns/10ps

module fa_test;
`define cycle 5

// wire and reg
reg clk;
reg a, b, ci;
wire sum, cout;

// clock gen
initial  clk = 0;
always #(`cycle/2) clk = ~clk;

// design module
fa i_fa(.a(a), .b(b), .ci(ci), .sum(sum), .cout(cout));

// test pattern
initial
begin
	@(posedge clk)
		a = 1'b0;
		b = 1'b0;
		ci = 1'b0;
		@(posedge clk)
			if ((sum != 0)|(cout != 0)|(sum===1'bz)|(cout===1'bz)|(sum===1'bx)|(cout===1'bx)) begin 
			$display($time, ,"a=%b, b=%b, ci=%b, sum=%b, cout=%b,  ERROR!!!", a,b,ci,sum,cout);  $finish; end
	@(posedge clk)
		a = 1'b0;
		b = 1'b0;
		ci = 1'b1;
		@(posedge clk)
			if ((sum != 1)|(cout != 0)|(sum===1'bz)|(cout===1'bz)|(sum===1'bx)|(cout===1'bx)) begin 
			$display($time, ,"a=%b, b=%b, ci=%b, sum=%b, cout=%b,  ERROR!!!", a,b,ci,sum,cout);  $finish; end
	@(posedge clk)
		a = 1'b0;
		b = 1'b1;
		ci = 1'b0;
		@(posedge clk)
			if ((sum != 1)|(cout != 0)|(sum===1'bz)|(cout===1'bz)|(sum===1'bx)|(cout===1'bx)) begin 
			$display($time, ,"a=%b, b=%b, ci=%b, sum=%b, cout=%b,  ERROR!!!", a,b,ci,sum,cout);  $finish; end
	@(posedge clk)
		a = 1'b0;
		b = 1'b1;
		ci = 1'b1;
		@(posedge clk)
			if ((sum != 0)|(cout != 1)|(sum===1'bz)|(cout===1'bz)|(sum===1'bx)|(cout===1'bx)) begin 
			$display($time, ,"a=%b, b=%b, ci=%b, sum=%b, cout=%b,  ERROR!!!", a,b,ci,sum,cout);  $finish; end
	@(posedge clk)
		a = 1'b1;
		b = 1'b0;
		ci = 1'b0;
		@(posedge clk)
			if ((sum != 1)|(cout != 0)|(sum===1'bz)|(cout===1'bz)|(sum===1'bx)|(cout===1'bx)) begin 
			$display($time, ,"a=%b, b=%b, ci=%b, sum=%b, cout=%b,  ERROR!!!", a,b,ci,sum,cout);  $finish; end
	@(posedge clk)
		a = 1'b1;
		b = 1'b0;
		ci = 1'b1;
		@(posedge clk)
			if ((sum != 0)|(cout != 1)|(sum===1'bz)|(cout===1'bz)|(sum===1'bx)|(cout===1'bx)) begin 
			$display($time, ,"a=%b, b=%b, ci=%b, sum=%b, cout=%b,  ERROR!!!", a,b,ci,sum,cout);  $finish; end
	@(posedge clk)
		a = 1'b1;
		b = 1'b1;
		ci = 1'b0;
		@(posedge clk)
			if ((sum != 0)|(cout != 1)|(sum===1'bz)|(cout===1'bz)|(sum===1'bx)|(cout===1'bx)) begin 
			$display($time, ,"a=%b, b=%b, ci=%b, sum=%b, cout=%b,  ERROR!!!", a,b,ci,sum,cout);  $finish; end
	@(posedge clk)
		a = 1'b1;
		b = 1'b1;
		ci = 1'b1;
		@(posedge clk)
			if ((sum != 1)|(cout != 1)|(sum===1'bz)|(cout===1'bz)|(sum===1'bx)|(cout===1'bx)) begin 
			$display($time, ,"a=%b, b=%b, ci=%b, sum=%b, cout=%b,  ERROR!!!", a,b,ci,sum,cout);  $finish; end
	@(posedge clk)
		$display("\n");
		$display("***********************");
		$display("function test pass !!");
		$display("***********************");
		$display("\n");
		$finish;

end


initial
begin
$fsdbDumpfile("fa.fsdb");
$fsdbDumpvars;
end



endmodule
