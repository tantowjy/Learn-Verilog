module mux_2_to_1_tb;

  // Input
  reg A;
  reg B;
  reg S;

  // Output
  wire out;

  // Instantiate the mux_2_1 module
  mux_2_to_1 uut (
    .A(A),
    .B(B),
    .S(S),
    .out(out)
  );

  // Test sequence
  initial begin
    A = 0; B = 0; S = 0;
    #10; 
    A = 0; B = 1; S = 0;
    #10;
    A = 1; B = 0; S = 0;
    #10; 
    A = 1; B = 1; S = 0;
    #10; 
    A = 0; B = 0; S = 1;
    #10;
    A = 0; B = 1; S = 1;
    #10;
    A = 1; B = 0; S = 1;
    #10;
    A = 1; B = 1; S = 1;
    #10;
  end

endmodule

