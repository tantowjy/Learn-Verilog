module sd_101_moore_tb;
    // Declare signals for the testbench
    reg clk;
    reg reset;
    reg data_in; 
    wire detect;     

    // Instantiate the sequence detector
    sd_101_moore uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .detect(detect)
    );

    // Clock generation
    initial begin
        clk = 0; // Initialize clock to 0
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test stimulus
    initial begin
        // Initialize signals
        reset = 1;      // Activate reset
        data_in = 0;
        
        #10;            // Wait for a few clock cycles
        reset = 0;      // Deactivate reset

        // Test input sequence
        #10 data_in = 1; 
        #10 data_in = 0; 
        #10 data_in = 1; 
        #10 data_in = 0; 
        #10 data_in = 1;         
        #10 data_in = 1; 
        #10 data_in = 0; 
        #10 data_in = 1; 
        #10 data_in = 0; 
        #10 data_in = 1; 
        #10 data_in = 1; 
        #10 data_in = 0; 
        #10 data_in = 1; 
            
        #10;
        $finish;
    end

endmodule 