module d_flip_flop_tb;
    reg         clk;
    reg  [3:0]  d;
    wire [3:0]  q;
    integer i;
    
    d_flip_flop uut (
        .clk(clk),
        .d(d),
        .q(q)
    );
    
    // Generate clock for 10 cycles
    initial begin
        clk = 0;
        for (i = 0; i < 10; i = i + 1) begin
            #5 clk = ~clk;
        end
    end
    
    initial begin
        clk = 0;
        d = 4'b0000; #10;
        d = 4'b1010; #10; // Set input d = 1010
        d = 4'b1100; #10; // Set input d = 1100
        d = 4'b1111; #10; // Set input d = 1111
        d = 4'b0001; #10; // Set input d = 0001
    end

endmodule 