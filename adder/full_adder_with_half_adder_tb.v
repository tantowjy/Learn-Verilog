module full_adder_with_half_adder_tb;

	reg A, B, Cin;
	wire Sum, Cout;

	full_adder_with_half_adder uut (
		.A(A),
		.B(B),
		.Cin(Cin),
		.Sum(Sum),
		.Cout(Cout)
	);

	initial begin
		A = 0; B = 0; Cin = 0; #10;
		A = 0; B = 0; Cin = 1; #10;
		A = 0; B = 1; Cin = 0; #10;
		A = 0; B = 1; Cin = 1; #10;
		A = 1; B = 0; Cin = 0; #10;
		A = 1; B = 0; Cin = 1; #10;
		A = 1; B = 1; Cin = 0; #10;
		A = 1; B = 1; Cin = 1; #10;
	end

endmodule 
