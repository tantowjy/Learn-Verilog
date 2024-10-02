module testbench_or_gate_d;

 reg a, b;
 wire y;

 or_gate_d uut (.a(a), .b(b), .y(y));
 
 initial begin
	a = 0; b = 0;
	#10;
	a = 0; b = 1;
	#10;
	a = 1; b = 0;
	#10;
	a = 1; b = 1;
	#10;
 end 
 
endmodule
