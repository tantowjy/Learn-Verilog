module mux_4_to_1_tb;
    reg d0, d1, d2, d3;
    reg s0, s1;
    wire y;

    mux_4_to_1 uut (.d0(d0), .d1(d1), .d2(d2), .d3(d3), .s0(s0), .s1(s1), .y(y));

    // Test sequence
    initial begin
        d0 = 1; d1 = 0; d2 = 0; d3 = 0;
        s1 = 0; s0 = 0;
        #10;

        d0 = 0; d1 = 1; d2 = 0; d3 = 0;
        s1 = 0; s0 = 1;
        #10;

        d0 = 0; d1 = 0; d2 = 1; d3 = 0;
        s1 = 1; s0 = 0;
        #10;

        d0 = 0; d1 = 0; d2 = 0; d3 = 1;
        s1 = 1; s0 = 1;
        #10;

        d0 = 0; d1 = 0; d2 = 0; d3 = 0;
        s1 = 0; s0 = 0;
        #10;

        d0 = 1; d1 = 1; d2 = 1; d3 = 1;
        s1 = 0; s0 = 1;
        #10;
    end

endmodule 