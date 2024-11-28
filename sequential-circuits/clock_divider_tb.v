module clock_divider_tb;
    // Testbench signals
    reg clkIn;           // Clock input signal
    reg enable;          // Enable signal for the clock divider
    reg [15:0] K;        // Clock frequency divider value
    wire clkOut;         // Output clock signal
    integer i;
    
    // Instantiate the DUT (Device Under Test)
    clock_divider #(16) uut (
        .clkIn(clkIn),
        .enable(enable),
        .K(K),
        .clkOut(clkOut)
    );
    
    // Clock generation	 
    initial begin
        clkIn = 0;
        for (i = 0; i < 52; i = i + 1) begin
            #10 clkIn = ~clkIn;
        end
    end
    
    // Test procedure
    initial begin
        // Initialize signals
        enable = 0;
        K = 16'd10;  // Set divider value (example: K = 10)
        
        // Start simulation
        #20;
        enable = 1;  // Enable clock divider
        #200;
        K = 16'd20;
        #200;
        
        // Disable clock divider
        enable = 0;
        #100;
    end

endmodule 