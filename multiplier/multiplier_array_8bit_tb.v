module multiplier_array_8bit_tb;
    reg [7:0] XA;
    reg [7:0] Y;
    wire [15:0] P;

    // Instantiate the multiplier
    multiplier_array_8bit uut (
        .XA(XA),
        .Y(Y),
        .P(P)
    );

    initial begin
        // Test case 1
        XA = 8'b00011001; // 25 in decimal
        Y = 8'b00000101;  // 5 in decimal
        #10;

        // Test case 2
        XA = 8'b11110000; // 240 in decimal
        Y = 8'b00001111;  // 15 in decimal
        #10;

        // Test case 3
        XA = 8'b10101010; // 170 in decimal
        Y = 8'b01010101;  // 85 in decimal
        #10;

        $stop;
    end
    
endmodule 