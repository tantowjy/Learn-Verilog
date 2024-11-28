module d_flip_flop_enable_reset_tb;
    reg clk;
    reg reset;
    reg en;
    reg [3:0] d;
    wire [3:0] q;
    integer i;
    
    d_flip_flop_enable_reset uut (
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d),
        .q(q)
    );
    
    initial begin
        clk = 0;
        for (i = 0; i < 20; i = i + 1) begin
            #5 clk = ~clk;
        end
    end
    
    initial begin
        clk = 0;
        reset = 0;
        en = 0;
        d = 4'b0;  #10; 
        reset = 1; #10;
        reset = 0; #10;
        reset = 1; #10;
        
        // Test
        en = 0; d = 4'b1010; #10;
        en = 1; d = 4'b1101; #10;
        d = 4'b0110; #10;
        en = 0; d = 4'b1111; #10;
        
        reset = 0; #10;
        reset = 1; #10;
    end

endmodule 