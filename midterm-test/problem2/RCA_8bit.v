module RCA_8bit (
    a, b, cin, sum, carry
);

    input [7:0] a;
    input [7:0] b;
    input cin;
    output [7:0] sum;
    output carry; 
    wire c1, c2, c3, c4, c5, c6, c7; 
    
    full_adder_one_bit FA0 (a[0], b[0], cin, sum[0], c1);
    full_adder_one_bit FA1 (a[1], b[1], c1, sum[1], c2);
    full_adder_one_bit FA2 (a[2], b[2], c2, sum[2], c3);
    full_adder_one_bit FA3 (a[3], b[3], c3, sum[3], c4);
    full_adder_one_bit FA4 (a[4], b[4], c4, sum[4], c5);
    full_adder_one_bit FA5 (a[5], b[5], c5, sum[5], c6);
    full_adder_one_bit FA6 (a[6], b[6], c6, sum[6], c7);
    full_adder_one_bit FA7 (a[7], b[7], c7, sum[7], carry);

endmodule 