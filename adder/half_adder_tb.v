module half_adder_tb;
    // Inputs
    reg A, B;
    
    // Outputs
    wire Sum, Carry;
    
    // Instantiate the half adder
    half_adder uut (
        .A(A),
        .B(B),
        .Sum(Sum),
        .Carry(Carry)
    );
    
    // Test stimulus
    initial begin
        A = 0; B = 0; #10;  // Expected: Sum = 0, Carry = 0
        A = 0; B = 1; #10;  // Expected: Sum = 1, Carry = 0
        A = 1; B = 0; #10;  // Expected: Sum = 1, Carry = 0
        A = 1; B = 1; #10;  // Expected: Sum = 0, Carry = 1
    end

endmodule
