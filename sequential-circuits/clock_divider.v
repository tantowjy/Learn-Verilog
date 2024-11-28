module clock_divider(
    clkIn,          // clock input signal to be divided
    enable,         // enable clk divider when high
    K,              // clock frequency divider is 2*(k+1)
    clkOut          // symmetric clock output Fout = Fin / 2*(k+1)
);

    parameter K_BIT = 16;    // change this for different number of bits divider

    //------------Input Ports------------------------
    input clkIn;
    input enable;
    input [K_BIT-1:0] K;
    
    //------------Output Ports-----------------------
    output clkOut;
    
    //------------Output Ports Data Type-------------
    // output port can be a storage element (reg) or a wire
    reg [K_BIT-1:0] count;
    reg clkOut;
    
    initial
        clkOut = 1'b0;
        
    //------------ Main Body of the module -----------
    always @ (posedge clkIn)
    begin
        if (enable == 1'b1) begin
            if (count == 10'b0) begin
                clkOut <= ~clkOut;         // toggle the clock output signal
                count <= K;               // shift right one bit
            end else
                count <= count - 1'b1;
        end
    end

endmodule 