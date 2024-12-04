module multiplier_shiftAdd_4bit_tb;
    // Input and output wires
    reg Clk;
    reg St;
    reg [3:0] Mplier;
    reg [3:0] Mcand;
    wire Done;
    wire [7:0] Result;

    // Instantiate the module
    multiplier_shiftAdd_4bit uut (
        .Clk(Clk),
        .St(St),
        .Mplier(Mplier),
        .Mcand(Mcand),
        .Done(Done),
        .Result(Result)
    );

    // Clock generation
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk; // 10 ns clock period
    end

    // Test procedure
    initial begin
        // Test 1: Multiply 3 (0011) x 2 (0010) = 6 (00000110)
        Mplier = 4'b0011;
        Mcand = 4'b0010;
        St = 0; #10;
        St = 1; #10;    // Start the operation
        St = 0;         // Clear the start signal
        wait(Done);     // Wait for the operation to complete
        #10;

        // Test 2: Multiply 5 (0101) x 3 (0011) = 15 (00001111)
        Mplier = 4'b0101;
        Mcand = 4'b0011;
        St = 0; #10;
        St = 1; #10;    // Start the operation
        St = 0;         // Clear the start signal
        wait(Done);     // Wait for the operation to complete
        #10;

        // Test 3: Multiply 7 (0111) x 4 (0100) = 28 (00011100)
        Mplier = 4'b0111;
        Mcand = 4'b0100;
        St = 0; #10;
        St = 1; #10;    // Start the operation
        St = 0;         // Clear the start signal
        wait(Done);     // Wait for the operation to complete
        #10;

        #10;
        $stop; // End simulation
    end

endmodule 
