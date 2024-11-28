module counter_sync(count, clk);
    output [3:0] count;  // 4-bit count value
    input clk;           // clock
    
    reg [3:0] count;
    
    initial begin
        count = 4'b0;
    end
    
    always @ (posedge clk)
        count <= count + 1'b1;

endmodule 