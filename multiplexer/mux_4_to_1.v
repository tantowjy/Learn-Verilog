module mux_4_to_1(
    input d0, d1,d2,d3, s0, s1,
    output reg y
);

    always @ (*) begin
        y = (~s1 & ~s0 & d0) | 
            (~s1 & s0 & d1) | 
            (s1 & ~s0 & d2) | 
            (s1 & s0 & d3);
    end

endmodule 