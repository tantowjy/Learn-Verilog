module mux_2_1 (
  input wire A,
  input wire B,
  input wire S,
  output wire out
);

 wire nS, y0, y1;

 not (nS, S);
 and (y0, A, nS);
 and (y1, B, S);

 or (out, y0, y1);

endmodule 
