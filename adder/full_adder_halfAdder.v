module full_adder_halfAdder(
    input wire A, B, Cin,   
    output wire Sum, Cout
);

    wire Sum1, Carry1, Carry2;
    
    half_adder ha1 (
        .A(A),
        .B(B),
        .Sum(Sum1),
        .Carry(Carry1)
    );
    
    half_adder ha2 (
        .A(Sum1),
        .B(Cin),
        .Sum(Sum),
        .Carry(Carry2)
    );
    
    assign Cout = Carry1 | Carry2;

endmodule 
