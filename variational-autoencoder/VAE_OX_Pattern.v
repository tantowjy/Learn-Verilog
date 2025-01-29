// Variational Autoencoder Neural Network

module VAE_OX_Pattern (
    input wire clk,                         // Clock signal
    input wire mode,                        // Mode: 1 = training, 0 = testing
    input wire In1, In2, In3,               // Input data signals (1-bit binary)
    input wire In4, In5, In6,               // Input data signals (1-bit binary)
    input wire In7, In8, In9,               // Input data signals (1-bit binary)
    input wire t1, t2, t3,                  // target data signals (1-bit binary)
    input wire t4, t5, t6,                  // target data signals (1-bit binary)
    input wire t7, t8, t9,                  // target data signals (1-bit binary)
    output reg trainingFinished,            // Indicates when training is completed
    output reg [15:0] Out1, Out2, Out3,     // Output after prediction (1-bit binary)
    output reg [15:0] Out4, Out5, Out6,     // Output after prediction (1-bit binary)
    output reg [15:0] Out7, Out8, Out9      // Output after prediction (1-bit binary)
);

    // Fixed-point format: Q16.16 (16 bits integer, 16 bits fractional)
    reg signed [31:0] w2_c1_1, w2_c1_2, w2_c1_3, w2_c1_4, w2_c1_5, w2_c1_6, w2_c1_7, w2_c1_8, w2_c1_9;
    reg signed [31:0] w2_d1_1, w2_d1_2, w2_d1_3, w2_d1_4, w2_d1_5, w2_d1_6, w2_d1_7, w2_d1_8, w2_d1_9;
    reg signed [31:0] w2_c2_1, w2_c2_2, w2_c2_3, w2_c2_4, w2_c2_5, w2_c2_6, w2_c2_7, w2_c2_8, w2_c2_9;
    reg signed [31:0] w2_d2_1, w2_d2_2, w2_d2_3, w2_d2_4, w2_d2_5, w2_d2_6, w2_d2_7, w2_d2_8, w2_d2_9;
    reg signed [31:0] b2_c1, b2_d1, b2_c2, b2_d2;

    reg signed [31:0] c1, a2_c1, d1, a2_d1, c2, a2_c2, d2, a2_d2;
    reg signed [31:0] eps1, eps2;

    reg signed [31:0] a2_1, a2_2;
    reg signed [31:0] E_rec, E_reg, E_total;
    reg signed [31:0] reconstruction_error;

    reg signed [31:0] w3_11, w3_12, w3_13, w3_14, w3_15, w3_16, w3_17, w3_18, w3_19;
    reg signed [31:0] w3_21, w3_22, w3_23, w3_24, w3_25, w3_26, w3_27, w3_28, w3_29;
    reg signed [31:0] b3_1, b3_2, b3_3, b3_4, b3_5, b3_6, b3_7, b3_8, b3_9;

    reg signed [31:0] z3_1, z3_2, z3_3, z3_4, z3_5, z3_6, z3_7, z3_8, z3_9;
    reg signed [31:0] a3_1, a3_2, a3_3, a3_4, a3_5, a3_6, a3_7, a3_8, a3_9;

    reg signed [31:0] delta_out1, delta_out2, delta_out3, delta_out4, delta_out5, delta_out6, delta_out7, delta_out8, delta_out9;
    reg signed [31:0] delta_a2_1, delta_a2_2;



    reg [31:0] data1[1:9], data2[1:9], data3[1:9], data4[1:9], data5[1:9], data6[1:9], data7[1:9], data8[1:9], data9[1:9];
    reg [31:0] dataTarget1[1:9], dataTarget2[1:9], dataTarget3[1:9], dataTarget4[1:9], dataTarget5[1:9];
    reg [31:0] dataTarget6[1:9], dataTarget7[1:9], dataTarget8[1:9], dataTarget9[1:9];
    
    
    // Indices and error counter
    integer i, j, k;

    // Parameters for learning
    // Convert 0.1 to Q16.16 format (0.1 * 2^16 = 6554)
    parameter signed [31:0] LEARNING_RATE = 32'h000006666;  
    // Convert 0.5 to Q16.16 format (0.5 * 2^16 = 32768)
    parameter signed [31:0] THRESHOLD = 32'h00008000;      
    parameter integer MAX_ITERATIONS = 500;

    // Function for multiplication of Q16.16 numbers
    function signed [31:0] multiply;
        input signed [31:0] a;
        input signed [31:0] b;
        reg signed [63:0] temp;
        begin
            temp = (a * b) >>> 16;  // Shift right by 16 to maintain Q16.16 format
            multiply = temp[31:0];
        end
    endfunction

    // Function for ReLU
    function signed [31:0] relu;
        input signed [31:0] inRelu;
        begin
            if (inRelu > 32'h00100000)
                relu = 32'h00100000;
            else
                relu = (inRelu > 0) ? inRelu : 0;
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
        // Setting values for w2_c1_1 to w2_c1_9
        w2_c1_1 = 32'h00008000; w2_c1_2 = 32'h00008000; w2_c1_3 = 32'h00008000;
        w2_c1_4 = 32'h00008000; w2_c1_5 = 32'h00008000; w2_c1_6 = 32'h00008000;
        w2_c1_7 = 32'h00008000; w2_c1_8 = 32'h00008000; w2_c1_9 = 32'h00008000;

        // Setting values for w2_d1_1 to w2_d1_9
        w2_d1_1 = 32'h00002000; w2_d1_2 = 32'h00002000; w2_d1_3 = 32'h00002000;
        w2_d1_4 = 32'h00002000; w2_d1_5 = 32'h00002000; w2_d1_6 = 32'h00002000;
        w2_d1_7 = 32'h00002000; w2_d1_8 = 32'h00002000; w2_d1_9 = 32'h00002000;

        // Setting values for w2_c2_1 to w2_c2_9
        w2_c2_1 = 32'h00002000; w2_c2_2 = 32'h00002000; w2_c2_3 = 32'h00002000;
        w2_c2_4 = 32'h00002000; w2_c2_5 = 32'h00002000; w2_c2_6 = 32'h00002000;
        w2_c2_7 = 32'h00002000; w2_c2_8 = 32'h00002000; w2_c2_9 = 32'h00002000;

        // Setting values for w2_d2_1 to w2_d2_9
        w2_d2_1 = 32'h00002000; w2_d2_2 = 32'h00002000; w2_d2_3 = 32'h00002000;
        w2_d2_4 = 32'h00002000; w2_d2_5 = 32'h00002000; w2_d2_6 = 32'h00002000;
        w2_d2_7 = 32'h00002000; w2_d2_8 = 32'h00002000; w2_d2_9 = 32'h00002000;

        // Setting values for w3_11 to w3_19
        w3_11 = 32'h00002000; w3_12 = 32'h00002000; w3_13 = 32'h00002000;
        w3_14 = 32'h00002000; w3_15 = 32'h00002000; w3_16 = 32'h00002000;
        w3_17 = 32'h00002000; w3_18 = 32'h00002000; w3_19 = 32'h00002000;

        // Setting values for w3_21 to w3_29
        w3_21 = 32'h00002000; w3_22 = 32'h00002000; w3_23 = 32'h00002000;
        w3_24 = 32'h00002000; w3_25 = 32'h00002000; w3_26 = 32'h00002000;
        w3_27 = 32'h00002000; w3_28 = 32'h00002000; w3_29 = 32'h00002000;

        // Initialize bias with 0.1 in Q16.16 format
        b2_c1 = 32'h00001966; b2_d1 = 32'h00001966; b2_c2 = 32'h00001966; b2_d2 = 32'h00001966;

        b3_1 = 32'h00001966; b3_2 = 32'h00001966; b3_3 = 32'h00001966;
        b3_4 = 32'h00001966; b3_5 = 32'h00001966; b3_6 = 32'h00001966;
        b3_7 = 32'h00001966; b3_8 = 32'h00001966; b3_9 = 32'h00001966;

        trainingFinished = 0;
        
        // Display header for debugging
        $display("Training started ...... ");
        $display("iteration | In1  In2  In3  In4  In5  In6  In7  In8  | t1  t2  t3  t4  t5  t6  t7  t8  | Out1\t Out2\t Out3\t Out4\t Out5\t Out6\t Out7\t Out8\t Out9\t");
        $display("------------------------------------------------------------------------------------------------------------------------------------------------------");
    end

    // Store training data
    always @(posedge clk) begin
        if (mode) begin
            data1[i] = In1;
            data2[i] = In2;
            data3[i] = In3;
            data4[i] = In4;
            data5[i] = In5;
            data6[i] = In6;
            data7[i] = In7;
            data8[i] = In8;
            data9[i] = In9;

            dataTarget1[i] = t1;
            dataTarget2[i] = t2;
            dataTarget3[i] = t3;
            dataTarget4[i] = t4;
            dataTarget5[i] = t5;
            dataTarget6[i] = t6;
            dataTarget7[i] = t7;
            dataTarget8[i] = t8;
            dataTarget9[i] = t9;

            i = i + 1;
        end
    end

    // Training process
    always @(posedge clk) begin
        if (!mode && !trainingFinished) begin

            for (j = 0; j < 8; j = j + 1) begin
                // Forward propagation
                // Hidden layer (first)
                c1 = multiply(to_fixed(data1[j]), w2_c1_1) + multiply(to_fixed(data2[j]), w2_c1_2) + multiply(to_fixed(data3[j]), w2_c1_3) +
                    multiply(to_fixed(data4[j]), w2_c1_4) + multiply(to_fixed(data5[j]), w2_c1_5) + multiply(to_fixed(data6[j]), w2_c1_6) +
                    multiply(to_fixed(data7[j]), w2_c1_7) + multiply(to_fixed(data8[j]), w2_c1_8) + multiply(to_fixed(data9[j]), w2_c1_9) + b2_c1;

                a2_c1 = relu(c1);

                d1 = multiply(to_fixed(data1[j]), w2_d1_1) + multiply(to_fixed(data2[j]), w2_d1_2) + multiply(to_fixed(data3[j]), w2_d1_3) +
                    multiply(to_fixed(data4[j]), w2_d1_4) + multiply(to_fixed(data5[j]), w2_d1_5) + multiply(to_fixed(data6[j]), w2_d1_6) +
                    multiply(to_fixed(data7[j]), w2_d1_7) + multiply(to_fixed(data8[j]), w2_d1_8) + multiply(to_fixed(data9[j]), w2_d1_9) + b2_d1;

                a2_d1 = relu(d1);
                
                c2 = multiply(to_fixed(data1[j]), w2_c2_1) + multiply(to_fixed(data2[j]), w2_c2_2) + multiply(to_fixed(data3[j]), w2_c2_3) +
                    multiply(to_fixed(data4[j]), w2_c2_4) + multiply(to_fixed(data5[j]), w2_c2_5) + multiply(to_fixed(data6[j]), w2_c2_6) +
                    multiply(to_fixed(data7[j]), w2_c2_7) + multiply(to_fixed(data8[j]), w2_c2_8) + multiply(to_fixed(data9[j]), w2_c2_9) + b2_c2;

                a2_c2 = relu(c2);
                
                d2 = multiply(to_fixed(data1[j]), w2_d2_1) + multiply(to_fixed(data2[j]), w2_d2_2) + multiply(to_fixed(data3[j]), w2_d2_3) +
                    multiply(to_fixed(data4[j]), w2_d2_4) + multiply(to_fixed(data5[j]), w2_d2_5) + multiply(to_fixed(data6[j]), w2_d2_6) +
                    multiply(to_fixed(data7[j]), w2_d2_7) + multiply(to_fixed(data8[j]), w2_d2_8) + multiply(to_fixed(data9[j]), w2_d2_9) + b2_d2;

                a2_d2 = relu(d2);

                eps1 = $random % 10000 / 10000.0;
                eps2 = $random % 10000 / 10000.0;

                a2_1 = a2_c1 + multiply($sqrt(a2_d1), to_fixed(eps1));
                a2_2 = a2_c2 + multiply($sqrt(a2_d2), to_fixed(eps2));

                // Output layer
                z3_1 = multiply(a2_1, w3_11) + multiply(a2_2, w3_21) + b3_1;
                z3_2 = multiply(a2_1, w3_12) + multiply(a2_2, w3_22) + b3_2;
                z3_3 = multiply(a2_1, w3_13) + multiply(a2_2, w3_23) + b3_3;
                z3_4 = multiply(a2_1, w3_14) + multiply(a2_2, w3_24) + b3_4;
                z3_5 = multiply(a2_1, w3_15) + multiply(a2_2, w3_25) + b3_5;
                z3_6 = multiply(a2_1, w3_16) + multiply(a2_2, w3_26) + b3_6;
                z3_7 = multiply(a2_1, w3_17) + multiply(a2_2, w3_27) + b3_7;
                z3_8 = multiply(a2_1, w3_18) + multiply(a2_2, w3_28) + b3_8;
                z3_9 = multiply(a2_1, w3_19) + multiply(a2_2, w3_29) + b3_9;

                a3_1 = relu(z3_1);
                a3_2 = relu(z3_2);
                a3_3 = relu(z3_3);
                a3_4 = relu(z3_4);
                a3_5 = relu(z3_5);
                a3_6 = relu(z3_6);
                a3_7 = relu(z3_7);
                a3_8 = relu(z3_8);
                a3_9 = relu(z3_9);

                Out1 = relu(z3_1);
                Out2 = relu(z3_2);
                Out3 = relu(z3_3);
                Out4 = relu(z3_4);
                Out5 = relu(z3_5);
                Out6 = relu(z3_6);
                Out7 = relu(z3_7);
                Out8 = relu(z3_8);
                Out9 = relu(z3_9);

                // Convert output to proper format with scaling and clamping
                Out1 = (z3_1 > 32'h00100000) ? 16'hFFFF : (z3_1[31:16] + z3_1[15]);
                Out2 = (z3_2 > 32'h00100000) ? 16'hFFFF : (z3_2[31:16] + z3_2[15]);
                Out3 = (z3_3 > 32'h00100000) ? 16'hFFFF : (z3_3[31:16] + z3_3[15]);
                Out4 = (z3_4 > 32'h00100000) ? 16'hFFFF : (z3_4[31:16] + z3_4[15]);
                Out5 = (z3_5 > 32'h00100000) ? 16'hFFFF : (z3_5[31:16] + z3_5[15]);
                Out6 = (z3_6 > 32'h00100000) ? 16'hFFFF : (z3_6[31:16] + z3_6[15]);
                Out7 = (z3_7 > 32'h00100000) ? 16'hFFFF : (z3_7[31:16] + z3_7[15]);
                Out8 = (z3_8 > 32'h00100000) ? 16'hFFFF : (z3_8[31:16] + z3_8[15]);
                Out9 = (z3_9 > 32'h00100000) ? 16'hFFFF : (z3_9[31:16] + z3_9[15]);

                // Reconstruction error (E_rec)
                E_rec = multiply(
                    (a3_1 - to_fixed(dataTarget1[j])) + 
                    (a3_2 - to_fixed(dataTarget2[j])) +
                    (a3_3 - to_fixed(dataTarget3[j])) +
                    (a3_4 - to_fixed(dataTarget4[j])) +
                    (a3_5 - to_fixed(dataTarget5[j])) +
                    (a3_6 - to_fixed(dataTarget6[j])) +
                    (a3_7 - to_fixed(dataTarget7[j])) +
                    (a3_8 - to_fixed(dataTarget8[j])) +
                    (a3_9 - to_fixed(dataTarget9[j])),
                    32'h00010000  // Scaling factor
                );

                // Regularization error (KL divergence)
                E_reg <= multiply(LEARNING_RATE, (multiply(a2_c1, a2_c1) + a2_d1 - $ln(a2_d1) - 1 +
                    multiply(a2_c2, a2_c2) + a2_d2 - $ln(a2_d2) - 1));

                // Total error
                E_total = E_rec + E_reg;

                // Backpropagation
                // Output layer deltas
                delta_out1 = a3_1 - to_fixed(dataTarget1[j]);
                delta_out2 = a3_2 - to_fixed(dataTarget2[j]);
                delta_out3 = a3_3 - to_fixed(dataTarget3[j]);
                delta_out4 = a3_4 - to_fixed(dataTarget4[j]);
                delta_out5 = a3_5 - to_fixed(dataTarget5[j]);
                delta_out6 = a3_6 - to_fixed(dataTarget6[j]);
                delta_out7 = a3_7 - to_fixed(dataTarget7[j]);
                delta_out8 = a3_8 - to_fixed(dataTarget8[j]);
                delta_out9 = a3_9 - to_fixed(dataTarget9[j]);

                // Hidden layer deltas
                delta_a2_1 = multiply(delta_out1, w3_11) + multiply(delta_out2, w3_12) +
                            multiply(delta_out3, w3_13) + multiply(delta_out4, w3_14) +
                            multiply(delta_out5, w3_15) + multiply(delta_out6, w3_16) +
                            multiply(delta_out7, w3_17) + multiply(delta_out8, w3_18) +
                            multiply(delta_out9, w3_19) + a2_c1;  // Add KL divergence gradient

                delta_a2_2 = multiply(delta_out1, w3_21) + multiply(delta_out2, w3_22) +
                            multiply(delta_out3, w3_23) + multiply(delta_out4, w3_24) +
                            multiply(delta_out5, w3_25) + multiply(delta_out6, w3_26) +
                            multiply(delta_out7, w3_27) + multiply(delta_out8, w3_28) +
                            multiply(delta_out9, w3_29) + a2_c2;  // Add KL divergence gradient

                // Update weights and biases
                // Output layer
                w3_11 = w3_11 - multiply(LEARNING_RATE, multiply(delta_out1, a2_1));
                w3_12 = w3_12 - multiply(LEARNING_RATE, multiply(delta_out2, a2_1));
                w3_13 = w3_13 - multiply(LEARNING_RATE, multiply(delta_out3, a2_1));
                w3_14 = w3_14 - multiply(LEARNING_RATE, multiply(delta_out4, a2_1));
                w3_15 = w3_15 - multiply(LEARNING_RATE, multiply(delta_out5, a2_1));
                w3_16 = w3_16 - multiply(LEARNING_RATE, multiply(delta_out6, a2_1));
                w3_17 = w3_17 - multiply(LEARNING_RATE, multiply(delta_out7, a2_1));
                w3_18 = w3_18 - multiply(LEARNING_RATE, multiply(delta_out8, a2_1));
                w3_19 = w3_19 - multiply(LEARNING_RATE, multiply(delta_out9, a2_1));

                w3_21 = w3_21 - multiply(LEARNING_RATE, multiply(delta_out1, a2_2));
                w3_22 = w3_22 - multiply(LEARNING_RATE, multiply(delta_out2, a2_2));
                w3_23 = w3_23 - multiply(LEARNING_RATE, multiply(delta_out3, a2_2));
                w3_24 = w3_24 - multiply(LEARNING_RATE, multiply(delta_out4, a2_2));
                w3_25 = w3_25 - multiply(LEARNING_RATE, multiply(delta_out5, a2_2));
                w3_26 = w3_26 - multiply(LEARNING_RATE, multiply(delta_out6, a2_2));
                w3_27 = w3_27 - multiply(LEARNING_RATE, multiply(delta_out7, a2_2));
                w3_28 = w3_28 - multiply(LEARNING_RATE, multiply(delta_out8, a2_2));
                w3_29 = w3_29 - multiply(LEARNING_RATE, multiply(delta_out9, a2_2));

                b3_1 = b3_1 - multiply(LEARNING_RATE, delta_out1);
                b3_2 = b3_2 - multiply(LEARNING_RATE, delta_out2);
                b3_3 = b3_3 - multiply(LEARNING_RATE, delta_out3);
                b3_4 = b3_4 - multiply(LEARNING_RATE, delta_out4);
                b3_5 = b3_5 - multiply(LEARNING_RATE, delta_out5);
                b3_6 = b3_6 - multiply(LEARNING_RATE, delta_out6);
                b3_7 = b3_7 - multiply(LEARNING_RATE, delta_out7);
                b3_8 = b3_8 - multiply(LEARNING_RATE, delta_out8);
                b3_9 = b3_9 - multiply(LEARNING_RATE, delta_out9);

                // Encoder weights (w2)
                // For mean (c1, c2)
                w2_c1_1 = w2_c1_1 - multiply(LEARNING_RATE, multiply(delta_a2_1, to_fixed(data1[j])));
                w2_c1_2 = w2_c1_2 - multiply(LEARNING_RATE, multiply(delta_a2_1, to_fixed(data2[j])));
                w2_c1_3 = w2_c1_3 - multiply(LEARNING_RATE, multiply(delta_a2_1, to_fixed(data3[j])));
                w2_c1_4 = w2_c1_4 - multiply(LEARNING_RATE, multiply(delta_a2_1, to_fixed(data4[j])));
                w2_c1_5 = w2_c1_5 - multiply(LEARNING_RATE, multiply(delta_a2_1, to_fixed(data5[j])));
                w2_c1_6 = w2_c1_6 - multiply(LEARNING_RATE, multiply(delta_a2_1, to_fixed(data6[j])));
                w2_c1_7 = w2_c1_7 - multiply(LEARNING_RATE, multiply(delta_a2_1, to_fixed(data7[j])));
                w2_c1_8 = w2_c1_8 - multiply(LEARNING_RATE, multiply(delta_a2_1, to_fixed(data8[j])));
                w2_c1_9 = w2_c1_9 - multiply(LEARNING_RATE, multiply(delta_a2_1, to_fixed(data9[j])));

                w2_c2_1 = w2_c2_1 - multiply(LEARNING_RATE, multiply(delta_a2_2, to_fixed(data1[j])));
                w2_c2_2 = w2_c2_2 - multiply(LEARNING_RATE, multiply(delta_a2_2, to_fixed(data2[j])));
                w2_c2_3 = w2_c2_3 - multiply(LEARNING_RATE, multiply(delta_a2_2, to_fixed(data3[j])));
                w2_c2_4 = w2_c2_4 - multiply(LEARNING_RATE, multiply(delta_a2_2, to_fixed(data4[j])));
                w2_c2_5 = w2_c2_5 - multiply(LEARNING_RATE, multiply(delta_a2_2, to_fixed(data5[j])));
                w2_c2_6 = w2_c2_6 - multiply(LEARNING_RATE, multiply(delta_a2_2, to_fixed(data6[j])));
                w2_c2_7 = w2_c2_7 - multiply(LEARNING_RATE, multiply(delta_a2_2, to_fixed(data7[j])));
                w2_c2_8 = w2_c2_8 - multiply(LEARNING_RATE, multiply(delta_a2_2, to_fixed(data8[j])));
                w2_c2_9 = w2_c2_9 - multiply(LEARNING_RATE, multiply(delta_a2_2, to_fixed(data9[j])));

                // For variance (d1, d2)
                w2_d1_1 = w2_d1_1 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d1), to_fixed(data1[j])));
                w2_d1_2 = w2_d1_2 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d1), to_fixed(data2[j])));
                w2_d1_3 = w2_d1_3 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d1), to_fixed(data3[j])));
                w2_d1_4 = w2_d1_4 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d1), to_fixed(data4[j])));
                w2_d1_5 = w2_d1_5 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d1), to_fixed(data5[j])));
                w2_d1_6 = w2_d1_6 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d1), to_fixed(data6[j])));
                w2_d1_7 = w2_d1_7 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d1), to_fixed(data7[j])));
                w2_d1_8 = w2_d1_8 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d1), to_fixed(data8[j])));
                w2_d1_9 = w2_d1_9 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d1), to_fixed(data9[j])));

                w2_d2_1 = w2_d2_1 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d2), to_fixed(data1[j])));
                w2_d2_2 = w2_d2_2 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d2), to_fixed(data2[j])));
                w2_d2_3 = w2_d2_3 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d2), to_fixed(data3[j])));
                w2_d2_4 = w2_d2_4 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d2), to_fixed(data4[j])));
                w2_d2_5 = w2_d2_5 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d2), to_fixed(data5[j])));
                w2_d2_6 = w2_d2_6 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d2), to_fixed(data6[j])));
                w2_d2_7 = w2_d2_7 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d2), to_fixed(data7[j])));
                w2_d2_8 = w2_d2_8 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d2), to_fixed(data8[j])));
                w2_d2_9 = w2_d2_9 - multiply(LEARNING_RATE, multiply(0.5 * (1 - 1/a2_d2), to_fixed(data9[j])));

                // Update biases
                b2_c1 = b2_c1 - multiply(LEARNING_RATE, delta_a2_1);
                b2_c2 = b2_c2 - multiply(LEARNING_RATE, delta_a2_2);
                b2_d1 = b2_d1 - multiply(LEARNING_RATE, 0.5 * (1 - 1/a2_d1));
                b2_d2 = b2_d2 - multiply(LEARNING_RATE, 0.5 * (1 - 1/a2_d2));

                // Counter for iteration
                k = k + 1;

                $display("%-4d | %-4.0f  %-4.0f  %-4.0f  %-4.0f  %-4.0f  %-4.0f  %-4.0f  %-4.0f %-4.0f | %-4.0f  %-4.0f  %-4.0f  %-4.0f  %-4.0f  %-4.0f  %-4.0f  %-4.0f %-4.0f 
                            | %-4.2f\t %-4.2f\t %-4.2f\t %-4.2f\t %-4.2f\t %-4.2f\t %-4.2f\t %-4.2f\t %-4.2f\t", 
                            k, data1[j], data2[j], data3[j], data4[j], data5[j], data6[j], data7[j], data8[j], data9[j],
                            dataTarget1[j], dataTarget2[j], dataTarget3[j], dataTarget4[j], dataTarget5[j], dataTarget6[j], 
                            dataTarget7[j], dataTarget8[j], dataTarget9[j],
                            to_fixed(Out1), to_fixed(Out2), to_fixed(Out3), to_fixed(Out4), to_fixed(Out5), to_fixed(Out6), 
                            to_fixed(Out7), to_fixed(Out8), to_fixed(Out9)
                );

                if (k >= MAX_ITERATIONS) begin
                    trainingFinished = 1;
                    $display("Training completed after reaching max iterations.");
                end
            end
        end
    end

    // Testing process
    always @(posedge clk) begin
        if (!mode && trainingFinished) begin
            // Forward propagation for testing
            // Encoder - Mean calculation (c1, c2)
            c1 = multiply(to_fixed(In1), w2_c1_1) + multiply(to_fixed(In2), w2_c1_2) + 
                multiply(to_fixed(In3), w2_c1_3) + multiply(to_fixed(In4), w2_c1_4) + 
                multiply(to_fixed(In5), w2_c1_5) + multiply(to_fixed(In6), w2_c1_6) + 
                multiply(to_fixed(In7), w2_c1_7) + multiply(to_fixed(In8), w2_c1_8) + 
                multiply(to_fixed(In9), w2_c1_9) + b2_c1;
            
            c2 = multiply(to_fixed(In1), w2_c2_1) + multiply(to_fixed(In2), w2_c2_2) + 
                multiply(to_fixed(In3), w2_c2_3) + multiply(to_fixed(In4), w2_c2_4) + 
                multiply(to_fixed(In5), w2_c2_5) + multiply(to_fixed(In6), w2_c2_6) + 
                multiply(to_fixed(In7), w2_c2_7) + multiply(to_fixed(In8), w2_c2_8) + 
                multiply(to_fixed(In9), w2_c2_9) + b2_c2;

            a2_c1 = relu(c1);
            a2_c2 = relu(c2);

            // Encoder - Variance calculation (d1, d2)
            d1 = multiply(to_fixed(In1), w2_d1_1) + multiply(to_fixed(In2), w2_d1_2) + 
                multiply(to_fixed(In3), w2_d1_3) + multiply(to_fixed(In4), w2_d1_4) + 
                multiply(to_fixed(In5), w2_d1_5) + multiply(to_fixed(In6), w2_d1_6) + 
                multiply(to_fixed(In7), w2_d1_7) + multiply(to_fixed(In8), w2_d1_8) + 
                multiply(to_fixed(In9), w2_d1_9) + b2_d1;
            
            d2 = multiply(to_fixed(In1), w2_d2_1) + multiply(to_fixed(In2), w2_d2_2) + 
                multiply(to_fixed(In3), w2_d2_3) + multiply(to_fixed(In4), w2_d2_4) + 
                multiply(to_fixed(In5), w2_d2_5) + multiply(to_fixed(In6), w2_d2_6) + 
                multiply(to_fixed(In7), w2_d2_7) + multiply(to_fixed(In8), w2_d2_8) + 
                multiply(to_fixed(In9), w2_d2_9) + b2_d2;

            a2_d1 = relu(d1);
            a2_d2 = relu(d2);

            a2_1 = a2_c1;  
            a2_2 = a2_c2;

            // Decoder - Reconstruction
            z3_1 = multiply(a2_1, w3_11) + multiply(a2_2, w3_21) + b3_1;
            z3_2 = multiply(a2_1, w3_12) + multiply(a2_2, w3_22) + b3_2;
            z3_3 = multiply(a2_1, w3_13) + multiply(a2_2, w3_23) + b3_3;
            z3_4 = multiply(a2_1, w3_14) + multiply(a2_2, w3_24) + b3_4;
            z3_5 = multiply(a2_1, w3_15) + multiply(a2_2, w3_25) + b3_5;
            z3_6 = multiply(a2_1, w3_16) + multiply(a2_2, w3_26) + b3_6;
            z3_7 = multiply(a2_1, w3_17) + multiply(a2_2, w3_27) + b3_7;
            z3_8 = multiply(a2_1, w3_18) + multiply(a2_2, w3_28) + b3_8;
            z3_9 = multiply(a2_1, w3_19) + multiply(a2_2, w3_29) + b3_9;

            // Apply activation function and set outputs
            Out1 = relu(z3_1);
            Out2 = relu(z3_2);
            Out3 = relu(z3_3);
            Out4 = relu(z3_4);
            Out5 = relu(z3_5);
            Out6 = relu(z3_6);
            Out7 = relu(z3_7);
            Out8 = relu(z3_8);
            Out9 = relu(z3_9);

        end
    end
endmodule 