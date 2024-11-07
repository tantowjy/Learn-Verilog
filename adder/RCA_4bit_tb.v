module RCA_4bit_tb;

  // Declare inputs as registers
  reg [3:0] a;
  reg [3:0] b;
  reg cin;

  // Declare outputs as wires
  wire [3:0] sum;
  wire carry;

  // Instantiate the RCA_4bit module
  RCA_4bit uut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .carry(carry)
  );

  // Test vector
  initial begin

    // Apply test cases
    a = 4'b0000; b = 4'b0000; cin = 1'b0; #10;
    a = 4'b0001; b = 4'b0001; cin = 1'b0; #10;
    a = 4'b0011; b = 4'b0101; cin = 1'b0; #10;
    a = 4'b1111; b = 4'b1111; cin = 1'b1; #10;
    a = 4'b1010; b = 4'b0101; cin = 1'b1; #10;

    // Finish simulation
    $finish;
  end

endmodule
