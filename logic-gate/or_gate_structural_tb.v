module or_gate_structural_tb;
	reg a, b;
	wire y;
	
	or_gate_structural uut (.a(a), .b(b), .y(y));
	
	initial begin
		a = 0; b = 0; #10;
		a = 0; b = 1; #10;
		a = 1; b = 0; #10;
		a = 1; b = 1; #10;
	end 
 
endmodule 