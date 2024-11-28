module f_dataflow_tb;
	reg A,B,C;
	wire F;
	
	f_dataflow uut (.A(A), .B(B), .C(C), .F(F));
	
	initial begin
		A = 0; B = 0; C=0; #10;
		A = 0; B = 0; C=1; #10;
		A = 0; B = 1; C=0; #10;
		A = 0; B = 1; C=1; #10;
		A = 1; B = 0; C=0; #10;
		A = 1; B = 0; C=1; #10;
		A = 1; B = 1; C=0; #10;
		A = 1; B = 1; C=1; #10;
	end

endmodule 