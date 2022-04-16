
module mux (out,a,b,sel);

// Port declarations
  output out;
  input a,b,sel;

// The netlist
  not u1(sel_, sel);
  and u2(a1, a, sel_); 
  and u3(b1, b, sel);
  or u4(out, a1, b1);




endmodule
