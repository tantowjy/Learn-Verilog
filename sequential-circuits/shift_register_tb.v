module shift_register_tb;
    reg clk, reset, D0, shift;
    wire [3:0] Q;
    integer i;
    
    shift_register uut (
        .clk(clk),
        .reset(reset),
        .D0(D0),
        .shift(shift),
        .Q(Q)
    );

    initial begin
        clk = 0;
        for (i = 0; i < 18; i = i + 1) begin
            #5 clk = ~clk;
        end
    end
    
    initial begin
        // Initialize inputs
        reset = 0;
        D0 = 0;
        shift = 0;
        
        // Apply reset
        #10;
        reset = 1; #10;
        
        // Shift operation
        D0 = 1; shift = 1; #10;
        D0 = 0; shift = 1; #10;
        D0 = 1; shift = 1; #10;
        D0 = 0; shift = 1; #10;
        
        // Hold shift
        shift = 0; #10;
        
        // Apply reset again
        reset = 0; #10;
        reset = 1; #10;
    end
    
endmodule 