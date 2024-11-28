module RCA_8bit_tb;
    reg [7:0] a;
    reg [7:0] b;
    reg cin;
    wire [7:0] sum;
    wire carry;
    
    RCA_8bit uut (.a(a), .b(b), .cin(cin), .sum(sum), .carry(carry));
    
    initial begin
        // Test Case 1:
        a = 8'b00001111;  // 15 decimal
        b = 8'b00000101;  // 5 decimal
        cin = 0;
        #10; 
        
        // Test Case 2:
        a = 8'b11110000;  // 240 decimal
        b = 8'b00001111;  // 15 decimal
        cin = 1;
        #10;
        
        // Test Case 3:
        a = 8'b11111111;  // 255 decimal
        b = 8'b11111111;  // 255 decimal
        cin = 0;
        #10;
    end

endmodule 