module  ha(a, b, sum, cout);
// input and output interface
input a, b;
output sum, cout;

// structural modeling
xor g1(sum, a, b);
and g2(cout, a, b);

endmodule
