module counter_decade(count, clk);
    output [3:0] count;  // 4-bit count value
    input clk;           // clock
    
    reg [3:0] count;
    
    initial begin
        count = 4'b0;
    end
    
    always @ (posedge clk)
        if (count == 4'd9)
            count <= 4'd0;
        else
            count <= count + 1'b1;

endmodule 