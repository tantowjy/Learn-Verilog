module full_adder_tb;
    reg A, B, Cin;
    wire Sum, Cout;

    full_adder uut (
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .Sum(Sum), 
        .Cout(Cout)
    );

    // Test sequence
    initial begin
        A = 0; B = 0; Cin = 0;
        #10; 
        A = 0; B = 0; Cin = 1;
        #10;
        A = 0; B = 1; Cin = 0;
        #10;
        A = 0; B = 1; Cin = 1;
        #10;
        A = 1; B = 0; Cin = 0;
        #10;
        A = 1; B = 0; Cin = 1;
        #10;
        A = 1; B = 1; Cin = 0;
        #10;
        A = 1; B = 1; Cin = 1;
        #10;
    end

endmodule 
