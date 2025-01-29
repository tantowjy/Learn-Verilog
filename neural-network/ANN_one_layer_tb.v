module ANN_one_layer_tb;
    reg clk, mode, In1, In2, In3, target;   // Declare inputs to the DUT
    wire trainingFinished, Out;             // Declare outputs from the DUT

    // Instantiate the module under test (DUT)
    ANN_one_layer uut (
        .clk(clk),
        .mode(mode),
        .In1(In1),
        .In2(In2),
        .In3(In3),
        .target(target),
        .trainingFinished(trainingFinished),
        .Out(Out)
    );
    
    // Iteration counter
    integer i;

    // Define clock period for simulation
    parameter CLOCK_PERIOD = 20;

    // Clock generation
    always begin
        clk = ~clk;
        #(CLOCK_PERIOD / 2);    // Generate clock with defined period
    end

    initial begin
        clk = 0; // Initialize clock signal
        
        #(CLOCK_PERIOD / 4);    // Initial delay before starting
        mode = 1;               // Set mode to training

        // Input dataset for training
        for (i = 0; i < 8; i = i + 1) begin
            {In3, In2, In1} = i[2:0]; // Assign inputs as binary representation of i
            target = In1 & In2 & In3; // Target output based on AND logic
            #(CLOCK_PERIOD);          // Wait for one clock cycle
        end

        mode = 0;                   // Set mode to testing
        In1 = 0; In2 = 0; In3 = 0;  // Initialize inputs for testing

        // Wait for training to finish
        while (!trainingFinished) #(CLOCK_PERIOD);

        // Display header for test results
        $display("\nIn3\tIn2\tIn1\t| OUTPUT");
        $display("=================================");

        // Test prediction for all input combinations
        for (i = 0; i < 8; i = i + 1) begin
            {In3, In2, In1} = i[2:0];                           // Assign inputs
            #(CLOCK_PERIOD / 2);                                // Allow time for output to stabilize
            $display("%b\t%b\t%b\t| %b", In3, In2, In1, Out);   // Display results
            #(CLOCK_PERIOD / 2);                                // Wait for the next cycle
        end

        $stop; // End simulation
    end
endmodule 