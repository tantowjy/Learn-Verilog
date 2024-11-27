module comparator_4bit(
    input [3:0] A,     // 4-bit input A
    input [3:0] B,     // 4-bit input B
    output A_gt_B,     // Output A > B
    output A_lt_B,     // Output A < B
    output A_eq_B      // Output A == B
);

    assign A_gt_B = (A > B);
    assign A_lt_B = (A < B);
    assign A_eq_B = (A == B);

endmodule 