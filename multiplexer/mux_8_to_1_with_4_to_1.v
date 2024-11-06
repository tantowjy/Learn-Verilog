module mux_8_to_1_with_4_to_1 (
    input d0, d1, d2, d3, d4, d5, d6, d7,
    input s0, s1, s2,
    output y
);
    wire y0, y1;

    mux_4_to_1 mux0 (
        .d0(d0), .d1(d1), .d2(d2), .d3(d3),
        .s0(s0), .s1(s1),
        .y(y0)
    );

    mux_4_to_1 mux1 (
        .d0(d4), .d1(d5), .d2(d6), .d3(d7),
        .s0(s0), .s1(s1),
        .y(y1)
    );

    assign y = (~s2 & y0) | (s2 & y1);
    
endmodule 