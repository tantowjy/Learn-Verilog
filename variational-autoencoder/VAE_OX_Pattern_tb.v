module VAE_OX_Pattern_tb;
    reg clk;
    reg mode;
    reg In1, In2, In3, In4, In5, In6, In7, In8, In9; // Individual input signals
    reg t1, t2, t3, t4, t5, t6, t7, t8, t9;         // Individual target signals
    wire trainingFinished;
    wire [15:0] Out1, Out2, Out3, Out4, Out5, Out6, Out7, Out8, Out9; // Adjusted output width

    // Test patterns
    reg [8:0] MARU = 9'b111101111;    // Circle pattern
    reg [8:0] BATU = 9'b101010101;    // Cross pattern
    reg [8:0] test_patterns [0:7];    // Reduced to 8 patterns for training
    reg [8:0] test_targets [0:7];
    
    integer i;

    // Instantiate VAE module
    VAE_OX_Pattern vae (
        .clk(clk),
        .mode(mode),
        .In1(In1), .In2(In2), .In3(In3), .In4(In4), .In5(In5),
        .In6(In6), .In7(In7), .In8(In8), .In9(In9),
        .t1(t1), .t2(t2), .t3(t3), .t4(t4), .t5(t5),
        .t6(t6), .t7(t7), .t8(t8), .t9(t9),
        .trainingFinished(trainingFinished),
        .Out1(Out1), .Out2(Out2), .Out3(Out3),
        .Out4(Out4), .Out5(Out5), .Out6(Out6),
        .Out7(Out7), .Out8(Out8), .Out9(Out9)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize test patterns
        test_patterns[0] = 9'b111101111;  // MARU
        test_patterns[1] = 9'b011101111;  // MARU + error
        test_patterns[2] = 9'b101101111;  // MARU + error
        test_patterns[3] = 9'b110101111;  // MARU + error
        test_patterns[4] = 9'b101010101;  // BATU
        test_patterns[5] = 9'b001010101;  // BATU + error
        test_patterns[6] = 9'b111010101;  // BATU + error
        test_patterns[7] = 9'b100010101;  // BATU + error

        // Initialize corresponding targets
        for (i = 0; i < 4; i = i + 1) begin
            test_targets[i] = MARU;
        end
        for (i = 4; i < 8; i = i + 1) begin
            test_targets[i] = BATU;
        end

        // Training phase
        $display("\nTraining Phase Begin");
        mode = 1;  // Training mode
        for (i = 0; i < 8; i = i + 1) begin
            {In1, In2, In3, In4, In5, In6, In7, In8, In9} = test_patterns[i];
            {t1, t2, t3, t4, t5, t6, t7, t8, t9} = test_targets[i];
            #10;
            $display("Input: %b | Target: %b", test_patterns[i], test_targets[i]);
        end

        // Switch to testing mode
        mode = 0;
        while (!trainingFinished) #10;

        $display("\nTraining completed!");

        // Testing phase
        $display("\nTesting Phase Begin");
        for (i = 0; i < 8; i = i + 1) begin
            {In1, In2, In3, In4, In5, In6, In7, In8, In9} = test_patterns[i];
            #10;
            $display("Input: %b | Outputs: %h %h %h %h %h %h %h %h %h",
                     test_patterns[i], Out1, Out2, Out3, Out4, Out5, Out6, Out7, Out8, Out9);
        end

        $finish;
    end

endmodule
