module decoder_2_to_4_tb;
    // Inputs
    reg [1:0] A;
    
    // Outputs
    wire [3:0] Y;
    
    // Instantiate the decoder
    decoder_2_to_4 uut (.A(A), .Y(Y));

    // Test stimulus
    initial begin
        // Apply all possible input combinations
        A = 2'b00; #10;  // Expected Y = 4'b0001
        A = 2'b01; #10;  // Expected Y = 4'b0010
        A = 2'b10; #10;  // Expected Y = 4'b0100
        A = 2'b11; #10;  // Expected Y = 4'b1000
        
        // Finish simulation
        $finish;
    end

endmodule 