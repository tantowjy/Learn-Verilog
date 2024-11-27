module RCA_4bit(
    a,b,cin,sum,carry
);
    
    input [3:0] a;
    input [3:0] b;
    input cin;
    output [3:0] sum;
    output carry;
    wire c1,c2,c3; //Internal connections
    
    full_adder FA0 (a[0], b[0], cin, sum[0], c1);
    full_adder FA1 (a[1], b[1], c1, sum[1], c2);
    full_adder FA2 (a[2], b[2], c2, sum[2], c3);
    full_adder FA3 (a[3], b[3], c3, sum[3], carry);

endmodule 
