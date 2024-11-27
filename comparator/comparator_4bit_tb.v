module comparator_4bit_tb;
    reg [3:0] A;
    reg [3:0] B;
    wire A_gt_B;
    wire A_lt_B;
    wire A_eq_B;
    
    comparator_4bit uut (
        .A(A),
        .B(B),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B),
        .A_eq_B(A_eq_B)
    );
    
    // Test sequence
    initial begin
        A = 4'b0010;  // A = 2
        B = 4'b0100;  // B = 4
        #10;
        
        A = 4'b1100;  // A = 12
        B = 4'b0110;  // B = 6
        #10;
        
        A = 4'b1010;  // A = 10
        B = 4'b1010;  // B = 10
        #10;
        
        A = 4'b0001;  // A = 1
        B = 4'b1111;  // B = 15
        #10;
    end

endmodule 