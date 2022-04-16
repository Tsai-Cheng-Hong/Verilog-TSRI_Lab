module fa(a, b, ci, sum, cout);
// input and output declaration
input  a, b, ci;
output sum, cout;

// wire and reg declaration
wire sum1, cout1, cout2;

// module instance
ha  u1(.a(a), .b(b), .sum(sum1), .cout(cout1));
ha  u2(.a(sum1), .b(ci), .sum(sum), .cout(cout2));
or  g1(cout, cout1, cout2);

endmodule
