module VAE_OX (
    input wire clk,
    input wire reset,
    input wire [8:0] InputX,                // Changing input to 9-bit
    input wire [8:0] target,                // Changing target to 9-bit
    input wire [8:0] learning_rate,         // Changing learning rate to 9-bit
    input wire [31:0] iteration,            // Number of iterations remains 32-bit
    output reg [8:0] w2_mean,               // Changing all parameters to 9-bit
    output reg [8:0] w2_var,
    output reg [8:0] w3,
    output reg [8:0] b2_mean,
    output reg [8:0] b2_var,
    output reg [8:0] b3,
    output reg [8:0] error         
);

    // Internal variable declarations
    reg [8:0] a2_mean, a2_var, z2_mean, z2_var;
    reg [8:0] a3, z3, eps;
    reg [31:0] i;                                   // Loop variable remains 32-bit

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize all parameters
            w2_mean <= 9'd1; 
            w2_var <= 9'd1;  
            w3 <= 9'd1;      
            b2_mean <= 9'd0; 
            b2_var <= 9'd0;  
            b3 <= 9'd0;      
            error <= 9'd255;  

        end else begin
            // Forward propagation and backpropagation
            for (i = 0; i < iteration; i = i + 1) begin
                // Forward Propagation
                z2_mean = w2_mean * InputX + b2_mean;
                z2_var = w2_var * InputX + b2_var;
                a2_mean = z2_mean;
                a2_var = z2_var;                        // Use a linear function
                z3 = w3 * a2_mean + b3;
                a3 = 1 / (1 + $exp(-z3));               // Sigmoid activation function
                
                // Error computation
                error = -target * $ln(a3) - (9'd1 - target) * $ln(9'd1 - a3);

                // Backpropagation
                w3 = w3 - learning_rate * (a2_mean * (a3 - target));
                b3 = b3 - learning_rate * (a3 - target);
                w2_mean = w2_mean - learning_rate * (InputX * (a3 - target));
                b2_mean = b2_mean - learning_rate * (a3 - target);
            end
        end
    end

endmodule 