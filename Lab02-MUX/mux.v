module mux (out, a, b, sel);
output out;
input a, b, sel;
wire out;

   assign out = (sel == 0) ? a : b;

endmodule