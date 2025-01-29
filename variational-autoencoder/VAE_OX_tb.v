module VAE_OX_tb;
    reg clk;                             // Clock signal
    reg reset;                           // Reset signal
    reg [8:0] InputX;                    // Input data (9-bit)
    reg [8:0] target;                    // Target data (9-bit)
    reg [8:0] learning_rate;             // Learning rate (9-bit)
    reg [31:0] iteration;                // Number of iterations (32-bit)
    wire [8:0] w2_mean, w2_var;          // Output weights (encoder)
    wire [8:0] w3;                       // Output weights (decoder)
    wire [8:0] b2_mean, b2_var;          // Output biases (encoder)
    wire [8:0] b3;                       // Output biases (decoder)
    wire [8:0] error;                    // error value (9-bit)

    // Instantiate the VAE module
    VAE_OX uut (
        .clk(clk),
        .reset(reset),
        .InputX(InputX),
        .target(target),
        .learning_rate(learning_rate),
        .iteration(iteration),
        .w2_mean(w2_mean),
        .w2_var(w2_var),
        .w3(w3),
        .b2_mean(b2_mean),
        .b2_var(b2_var),
        .b3(b3),
        .error(error)
    );

    // Clock generation
    always #5 clk = ~clk;  // Clock with a 10ns period

    initial begin
        // Initialization
        clk = 0;
        reset = 1;
        InputX = 9'b101101111;       // Initial input data in binary
        target = 9'b111101111;       // Initial target data in binary
        learning_rate = 9'b000000001; 
        iteration = 32'd10;          // Initial iteration value (decimal remains)

        // Reset the module
        #10 reset = 0;

        // Test case
        #10;  // MARU
        InputX = 9'b111101111; target = 9'b111101111;    

        #50;  // MARU + error
        InputX = 9'b011101111; target = 9'b111101111;       

        #50;  // MARU + error
        InputX = 9'b101101111; target = 9'b111101111; 

        #50;  // MARU + error
        InputX = 9'b110101111; target = 9'b111101111;       

        #50;  // BATU
        InputX = 9'b101010101; target = 9'b101010101; 

        #50;  // BATU + error
        InputX = 9'b001010101; target = 9'b101010101;       

        #50;  // BATU + error
        InputX = 9'b111010101; target = 9'b101010101;  

        #50;  // BATU + error
        InputX = 9'b100010101; target = 9'b101010101; 

        // End simulation
        #50;
        $stop;
    end

    // Monitor output signals
    initial begin
        $monitor("Time: %0d, InputX: %b, target: %b, w2_mean: %b, w2_var: %b, w3: %b, b2_mean: %b, b2_var: %b, b3: %b, error: %b",
                 $time, InputX, target, w2_mean, w2_var, w3, b2_mean, b2_var, b3, error);
    end

endmodule
