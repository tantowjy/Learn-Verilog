module full_adder(
    input A, B, Cin, 
    output Sum, Cout
);

    // Wires
    wire xor1;
    wire and1;
    wire and2;
    
    // Sum
    xor (xor1, A, B);        // xor1 = A ^ B
    xor (Sum, xor1, Cin);   // Sum = xor1 ^ Cin
    
    // Cout
    and (and1, A, B);        // and1 = A B
    and (and2, xor1, Cin);   // and2 = xor1 . Cin
    or (Cout, and1, and2);   // Cout = and1 + and2

endmodule 
