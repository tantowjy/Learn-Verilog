// OR gate using data flow modeling
module or_gate_d (y,a,b);

input a,b;
output y;

assign y = (a | b);

endmodule 