module counter_decade_tb;
    reg clk;
    wire [3:0] count;
    integer i;
    
    counter_decade uut (
        .count(count), 
        .clk(clk)
    );
    
    initial begin
        clk = 0;
        for (i = 0; i < 20; i = i + 1) begin
            #5 clk = ~clk;
        end
    end
    
    initial begin
        #100;
    end

endmodule 