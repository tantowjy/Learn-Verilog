// OR gate using behavioural modeling
module or_gate_behavioural(y,a,b);

	input a, b;
	output reg y;

	always @ (a or b)
	begin
		y = a | b;
	end

endmodule 