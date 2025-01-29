// Logic with Neural Network
// 1 Layer, 3 Input, 1 Output, Without Bias

module ANN_one_layer (
    input wire clk,                  // Clock signal
    input wire mode,                 // Mode: 1 = training, 0 = testing
    input wire In1, In2, In3,        // Input data signals
    input wire target,               // Target output for training
    output reg trainingFinished,     // Indicates when training is completed
    output reg Out                   // Output after prediction
);

    // Weight variables for inputs (16-bit representation)
    reg [15:0] w1, w2, w3, wOut;     // Weights and weighted sum
    reg [15:0] LEARNING_RATE = 16'd1; // Learning rate as a fixed 16-bit value
    reg [15:0] THRESHOLD = 16'd10;   // Threshold for output prediction in scaled 16-bit integer

    // Indices and error counter
    reg [15:0] i, j, k;               // 4-bit counters for up to 16 samples
    reg errorFlag;                   // Error flag for training status

    // Input and target storage for training data
    reg [7:0] data1, data2, data3, dataTarget; // 8-bit storage for training samples
    reg predicted;                   // Predicted output during training

    // Initialization block
    initial begin
        i = 0; k = 0;                // Initialize counters
        w1 = 16'd0; w2 = 16'd0; w3 = 16'd0; // Initialize weights to zero
        trainingFinished = 0;        // Training not finished at the start
        
        // Display header for debugging output
        $display("iter | In1\t In2\t In3\t target | w1\t w2\t w3\t value   | predict  \t status");
        $display("-----------------------------------------------------------------------------");
    end

    // Store training data during training mode
    always @(posedge clk) begin
        if (mode) begin              // Check if mode is training
            data1[i] = In1;
            data2[i] = In2;
            data3[i] = In3;
            dataTarget[i] = target;
            i = i + 1;               // Increment training data index
        end
    end

    // Training process
    always @(posedge clk) begin
        if (!mode && !trainingFinished) begin // Training happens only when mode is 0 and training is not finished
            errorFlag = 0;           // Reset error flag

            // Iterate over all training samples
            for (j = 0; j < 8 && errorFlag == 0; j = j + 1) begin
                // Compute weighted sum
                wOut = (data1[j] * w1) + (data2[j] * w2) + (data3[j] * w3);

                // Apply threshold to determine prediction
                predicted = (wOut >= THRESHOLD) ? 1 : 0;

                k = k + 1;          // Increment iteration counter

                // Check if prediction matches the target
                if (predicted != dataTarget[j]) begin
                    // Display debug information for a misprediction
                    $display("%-4d | %-4b\t %-4b\t %-4b\t %-4b | %-4d\t %-4d\t %-4d\t %-4d | %-4b     \t BAD", k, data1[j], data2[j], data3[j], dataTarget[j], w1, w2, w3, wOut, predicted);

                    // Adjust weights based on error
                    errorFlag = 1;
                    w1 = w1 + (LEARNING_RATE * data1[j] * (dataTarget[j] - predicted));
                    w2 = w2 + (LEARNING_RATE * data2[j] * (dataTarget[j] - predicted));
                    w3 = w3 + (LEARNING_RATE * data3[j] * (dataTarget[j] - predicted));
                end else begin
                    // Display debug information for a correct prediction
                    $display("%-4d | %-4b\t %-4b\t %-4b\t %-4b | %-4d\t %-4d\t %-4d\t %-4d | %-4b    \t GOOD", k, data1[j], data2[j], data3[j], dataTarget[j], w1, w2, w3, wOut, predicted);
                end
            end

            // If no errors were encountered, training is complete
            if (errorFlag == 0) trainingFinished = 1;
        end
    end

    // Testing process
    always @(posedge clk) begin
        if (!mode && trainingFinished) begin
            // Compute weighted sum for testing input
            wOut = (In1 * w1) + (In2 * w2) + (In3 * w3);

            // Apply threshold to produce output
            Out = (wOut >= THRESHOLD) ? 1 : 0;
        end
    end
endmodule 