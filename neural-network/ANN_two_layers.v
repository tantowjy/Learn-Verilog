// Logic with Neural Network
// 2 Layer, 3 Input, 1 Output, With Bias


module ANN_two_layers (
    input wire clk,                  // Clock signal
    input wire mode,                 // Mode: 1 = training, 0 = testing
    input wire In1, In2, In3,        // Input data signals (1-bit binary)
    input wire target,               // Target output for training (1-bit binary)
    output reg trainingFinished,     // Indicates when training is completed
    output reg Out                   // Output after prediction (1-bit binary)
);

    // Fixed-point format: Q16.16 (16 bits integer, 16 bits fractional)
    // Weight variables for inputs and hidden layer
    reg signed [31:0] w1, w2, w3, w4, w5, w6, w7, w8;    // Weights for both layers
    reg signed [31:0] S1, S2, S3, Out1, Out2, Out3;      // Layer outputs and weighted sums
    reg signed [31:0] b1, b2, b3;                        // Bias values
    reg signed [31:0] delta_output, delta1, delta2;       // Deltas for backpropagation
    
    // Indices and error counter
    integer i, j, k;
    reg errorFlag;                   // Error flag for training status

    // Input and target storage for training data
    reg [7:0] data1[0:7], data2[0:7], data3[0:7], dataTarget[0:7];
    reg predicted;                   // Predicted output during training (1-bit)

    // Parameters for learning
    // Convert 0.1 to Q16.16 format (0.1 * 2^16 = 6554)
    parameter signed [31:0] LEARNING_RATE = 32'h00001966;  
    // Convert 0.5 to Q16.16 format (0.5 * 2^16 = 32768)
    parameter signed [31:0] THRESHOLD = 32'h00008000;      
    parameter integer MAX_ITERATIONS = 500;

    // Helper function for multiplication of Q16.16 numbers
    function signed [31:0] multiply;
        input signed [31:0] a;
        input signed [31:0] b;
        reg signed [63:0] temp;
        begin
            temp = (a * b) >>> 16;  // Shift right by 16 to maintain Q16.16 format
            multiply = temp[31:0];
        end
    endfunction

    // Helper function for ReLU
    function signed [31:0] relu;
        input signed [31:0] x;
        begin
            relu = (x > 0) ? x : 0;
        end
    endfunction

    // Convert 1-bit to Q16.16 format
    function signed [31:0] to_fixed;
        input bit;
        begin
            to_fixed = bit ? 32'h00010000 : 0; // 1.0 or 0.0 in Q16.16
        end
    endfunction

    // Initialization block
    initial begin
        i = 0; k = 0;
        // Initialize weights with small values in Q16.16 format (0.125 * 2^16 = 8192)
        w1 = 32'h00002000; w2 = 32'h00002000; w3 = 32'h00002000; w4 = 32'h00002000;
        w5 = 32'h00002000; w6 = 32'h00002000; w7 = 32'h00002000; w8 = 32'h00002000;
        // Initialize bias with 0.1 in Q16.16 format
        b1 = 32'h00001966; b2 = 32'h00001966; b3 = 32'h00001966;
        trainingFinished = 0;
        
        // Display header for debugging
        $display("Training started - Fixed Point Implementation with Binary I/O");
        $display("iter | In1\t In2\t In3\t target | Pred\t  Status");
        $display("------------------------------------------------");
    end

    // Store training data
    always @(posedge clk) begin
        if (mode) begin
            data1[i] = In1;
            data2[i] = In2;
            data3[i] = In3;
            dataTarget[i] = target;
            i = i + 1;
        end
    end

    // Training process
    always @(posedge clk) begin
        if (!mode && !trainingFinished) begin
            errorFlag = 0;

            for (j = 0; j < 8 && errorFlag == 0; j = j + 1) begin
                // Forward propagation
                // Hidden layer
                S1 = multiply(to_fixed(data1[j]), w1) + multiply(to_fixed(data2[j]), w2) + 
                     multiply(to_fixed(data3[j]), w3) + b1;
                S2 = multiply(to_fixed(data1[j]), w4) + multiply(to_fixed(data2[j]), w5) + 
                     multiply(to_fixed(data3[j]), w6) + b2;
                Out1 = relu(S1);
                Out2 = relu(S2);

                // Output layer
                S3 = multiply(Out1, w7) + multiply(Out2, w8) + b3;
                Out3 = relu(S3);
                
                predicted = (Out3 >= THRESHOLD) ? 1'b1 : 1'b0;
                
                k = k + 1;

                if (predicted != dataTarget[j]) begin
                    errorFlag = 1;
                    
                    // Backpropagation
                    // Output layer
                    delta_output = to_fixed(dataTarget[j]) - Out3;
                    
                    // Hidden layer
                    delta1 = multiply(delta_output, w7);
                    delta2 = multiply(delta_output, w8);
                    
                    // Update weights
                    // Output layer
                    w7 = w7 + multiply(multiply(LEARNING_RATE, Out1), delta_output);
                    w8 = w8 + multiply(multiply(LEARNING_RATE, Out2), delta_output);
                    b3 = b3 + multiply(LEARNING_RATE, delta_output);
                    
                    // Hidden layer
                    w1 = w1 + multiply(multiply(LEARNING_RATE, to_fixed(data1[j])), delta1);
                    w2 = w2 + multiply(multiply(LEARNING_RATE, to_fixed(data2[j])), delta1);
                    w3 = w3 + multiply(multiply(LEARNING_RATE, to_fixed(data3[j])), delta1);
                    w4 = w4 + multiply(multiply(LEARNING_RATE, to_fixed(data1[j])), delta2);
                    w5 = w5 + multiply(multiply(LEARNING_RATE, to_fixed(data2[j])), delta2);
                    w6 = w6 + multiply(multiply(LEARNING_RATE, to_fixed(data3[j])), delta2);
                    b1 = b1 + multiply(LEARNING_RATE, delta1);
                    b2 = b2 + multiply(LEARNING_RATE, delta2);

                    $display("%-4d | %-4.0f\t %-4.0f\t %-4.0f\t %-4.0f | %-4.2f\t BAD", 
                            k, data1[j], data2[j], data3[j], dataTarget[j], predicted);
                end else begin
                    $display("%-4d | %-4.0f\t %-4.0f\t %-4.0f\t %-4.0f | %-4.2f\t GOOD", 
                            k, data1[j], data2[j], data3[j], dataTarget[j], predicted);
                end

                // if (k >= MAX_ITERATIONS) begin
                //     trainingFinished = 1;
                //     $display("Training completed after reaching max iterations.");
                // end
            end
            
            // If no errors were encountered, training is complete
            if (errorFlag == 0) trainingFinished = 1;
        end
    end

    // Testing process
    always @(posedge clk) begin
        if (!mode && trainingFinished) begin
            // Forward propagation for testing
            S1 = multiply(to_fixed(In1), w1) + multiply(to_fixed(In2), w2) + 
                 multiply(to_fixed(In3), w3) + b1;
            S2 = multiply(to_fixed(In1), w4) + multiply(to_fixed(In2), w5) + 
                 multiply(to_fixed(In3), w6) + b2;
            Out1 = relu(S1);
            Out2 = relu(S2);
            S3 = multiply(Out1, w7) + multiply(Out2, w8) + b3;
            Out3 = relu(S3);
            
            Out = (Out3 >= THRESHOLD) ? 1'b1 : 1'b0;
        end
    end
endmodule 