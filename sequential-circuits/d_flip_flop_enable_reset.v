module d_flip_flop_enable_reset(
    input            clk, reset, en,
    input      [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk or negedge reset) begin
        if (reset == 1'b0)
            q <= 4'b0;
        else if(en)
            q <= d;
    end

endmodule 