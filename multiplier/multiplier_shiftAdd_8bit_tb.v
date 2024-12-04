module multiplier_shiftAdd_8bit_tb;
    // Input and output wires
    reg Clk;
    reg St;
    reg [7:0] Mplier;
    reg [7:0] Mcand;
    wire Done;
    wire [15:0] Result;

    // Instantiate the module
    multiplier_shiftAdd_8bit uut (
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
        // Test 1: Multiply 195 (11000011) x 194 (11000010) = 37830 (1001 0011 1100 0110)
        Mplier = 8'b11000011;
        Mcand = 8'b11000010;
        St = 0; #10;
        St = 1; #10;    // Start the operation
        St = 0;         // Clear the start signal
        wait(Done);     // Wait for the operation to complete
        #10;

        // Test 2: Multiply 5 (0101) x 3 (0011) = 15 (00001111)
        Mplier = 8'b0101;
        Mcand = 8'b0011;
        St = 0; #10;
        St = 1; #10;    // Start the operation
        St = 0;         // Clear the start signal
        wait(Done);     // Wait for the operation to complete
        #10;

        // Test 3: Multiply 7 (0111) x 132 (10000100) = 924 (0011 1001 1100)
        Mplier = 8'b0111;
        Mcand = 8'b10000100;
        St = 0; #10;
        St = 1; #10;    // Start the operation
        St = 0;         // Clear the start signal
        wait(Done);     // Wait for the operation to complete
        #10;

        #10;
        $stop; // End simulation
    end

endmodule 