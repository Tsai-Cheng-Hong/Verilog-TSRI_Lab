/*************************************************************************
 * Positive edge-triggered D Flip-Flop model using path delays, timing 
 * checks, and the notifier - Verilog Training Course, Lab 3.
 ************************************************************************/


`celldefine
module dffr_b(clr_,clk,q,q_,d);
    output q, q_;
    input  clr_, clk, d;

    reg flag;

    nand  n1 (de, dl, qe);
    nand  n2 (qe, clk, de, clr_);
    nand  n3 (dl, d, dl_, clr_);
    nand  n4 (dl_, dl, clk, qe);
    nand  n5 (q, qe, q_);
    nand  n6 (q_, dl_, q, clr_);

  specify

   $setuphold(posedge clk, d, 3:5:6, 2:3:6, flag);

   (clr_ *> q, q_) = 3;
   (clk *> q)     = (2:3:5, 4:5:6);
   (clk *> q_)    = (2:4:5, 3:5:6);

  endspecify

endmodule
`endcelldefine

