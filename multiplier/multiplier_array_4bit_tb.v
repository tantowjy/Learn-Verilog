module multiplier_array_4bit_tb;
    // Declare input and output signals for the multiplier
    reg [3:0] XA; 
    reg [3:0] Y;
    wire [7:0] P;
    
    // Instantiate the multiplier module
    multiplier_array_4bit uut (
        .XA(XA),
        .Y(Y),
        .P(P)
    );

    // Initialize the inputs and run 3 test cases
    initial begin
        // Test case 1: Multiplying 4'b1010 (10) and 4'b1101 (13)
        XA = 4'b1010; 
        Y = 4'b1101;
        #10;
        
        // Test case 2: Multiplying 4'b1111 (15) and 4'b1111 (15)
        XA = 4'b1111; 
        Y = 4'b1111;
        #10;
        
        // Test case 3: Multiplying 4'b0001 (1) and 4'b0001 (1)
        XA = 4'b0001; 
        Y = 4'b0001;
        #10;

        // End simulation
        #10;
        $finish;
    end
    
endmodule 
