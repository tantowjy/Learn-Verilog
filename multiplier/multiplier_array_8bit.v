module multiplier_array_8bit (
    input[7:0] XA,
    input[7:0] Y,
    output [15:0] P
);

    wire[7:0] XYO;
    wire[7:0] XY1;
    wire[7:0] XY2; 
    wire[7:0] XY3;
    wire[7:0] XY4;
    wire[7:0] XY5;
    wire[7:0] XY6;
    wire[7:0] XY7;

    wire[7:0] C1;
    wire[7:0] C2;
    wire[7:0] C3;
    wire[7:0] C4;
    wire[7:0] C5;
    wire[7:0] C6;
    wire[7:0] C7;

    wire[7:0] S1;
    wire[7:0] S2;
    wire[7:0] S3;
    wire[7:0] S4;
    wire[7:0] S5;
    wire[7:0] S6;
    wire[7:0] S7;

    // Partial Product Generation
    assign XYO[0] = XA[0] & Y[0]; 
    assign XYO[1] = XA[0] & Y[1]; 
    assign XYO[2] = XA[0] & Y[2]; 
    assign XYO[3] = XA[0] & Y[3];
    assign XYO[4] = XA[0] & Y[4];
    assign XYO[5] = XA[0] & Y[5];
    assign XYO[6] = XA[0] & Y[6];
    assign XYO[7] = XA[0] & Y[7];

    assign XY1[0] = XA[1] & Y[0]; 
    assign XY1[1] = XA[1] & Y[1]; 
    assign XY1[2] = XA[1] & Y[2]; 
    assign XY1[3] = XA[1] & Y[3];
    assign XY1[4] = XA[1] & Y[4];
    assign XY1[5] = XA[1] & Y[5];
    assign XY1[6] = XA[1] & Y[6];
    assign XY1[7] = XA[1] & Y[7];

    assign XY2[0] = XA[2] & Y[0]; 
    assign XY2[1] = XA[2] & Y[1]; 
    assign XY2[2] = XA[2] & Y[2]; 
    assign XY2[3] = XA[2] & Y[3];
    assign XY2[4] = XA[2] & Y[4];
    assign XY2[5] = XA[2] & Y[5];
    assign XY2[6] = XA[2] & Y[6];
    assign XY2[7] = XA[2] & Y[7];

    assign XY3[0] = XA[3] & Y[0]; 
    assign XY3[1] = XA[3] & Y[1]; 
    assign XY3[2] = XA[3] & Y[2]; 
    assign XY3[3] = XA[3] & Y[3];
    assign XY3[4] = XA[3] & Y[4];
    assign XY3[5] = XA[3] & Y[5];
    assign XY3[6] = XA[3] & Y[6];
    assign XY3[7] = XA[3] & Y[7];

    assign XY4[0] = XA[4] & Y[0]; 
    assign XY4[1] = XA[4] & Y[1]; 
    assign XY4[2] = XA[4] & Y[2]; 
    assign XY4[3] = XA[4] & Y[3];
    assign XY4[4] = XA[4] & Y[4];
    assign XY4[5] = XA[4] & Y[5];
    assign XY4[6] = XA[4] & Y[6];
    assign XY4[7] = XA[4] & Y[7];

    assign XY5[0] = XA[5] & Y[0]; 
    assign XY5[1] = XA[5] & Y[1]; 
    assign XY5[2] = XA[5] & Y[2]; 
    assign XY5[3] = XA[5] & Y[3];
    assign XY5[4] = XA[5] & Y[4];
    assign XY5[5] = XA[5] & Y[5];
    assign XY5[6] = XA[5] & Y[6];
    assign XY5[7] = XA[5] & Y[7];

    assign XY6[0] = XA[6] & Y[0]; 
    assign XY6[1] = XA[6] & Y[1]; 
    assign XY6[2] = XA[6] & Y[2]; 
    assign XY6[3] = XA[6] & Y[3];
    assign XY6[4] = XA[6] & Y[4];
    assign XY6[5] = XA[6] & Y[5];
    assign XY6[6] = XA[6] & Y[6];
    assign XY6[7] = XA[6] & Y[7];

    assign XY7[0] = XA[7] & Y[0]; 
    assign XY7[1] = XA[7] & Y[1]; 
    assign XY7[2] = XA[7] & Y[2]; 
    assign XY7[3] = XA[7] & Y[3];
    assign XY7[4] = XA[7] & Y[4];
    assign XY7[5] = XA[7] & Y[5];
    assign XY7[6] = XA[7] & Y[6];
    assign XY7[7] = XA[7] & Y[7];

    // First Row of Half and Full Adders
    HalfAdder HA1 (XYO[1], XY1[0], C1[0], S1[0]);
    FullAdder FA1 (XYO[2], XY1[1], C1[0], C1[1], S1[1]);
    FullAdder FA2 (XYO[3], XY1[2], C1[1], C1[2], S1[2]);
    FullAdder FA3 (XYO[4], XY1[3], C1[2], C1[3], S1[3]);
    FullAdder FA4 (XYO[5], XY1[4], C1[3], C1[4], S1[4]);
    FullAdder FA5 (XYO[6], XY1[5], C1[4], C1[5], S1[5]);
    FullAdder FA6 (XYO[7], XY1[6], C1[5], C1[6], S1[6]);
    HalfAdder HA2 (XY1[7], C1[6], C1[7], S1[7]);

    // Second Row
    HalfAdder HA3 (S1[1], XY2[0], C2[0], S2[0]);
    FullAdder FA7 (S1[2], XY2[1], C2[0], C2[1], S2[1]);
    FullAdder FA8 (S1[3], XY2[2], C2[1], C2[2], S2[2]);
    FullAdder FA9 (S1[4], XY2[3], C2[2], C2[3], S2[3]);
    FullAdder FA10 (S1[5], XY2[4], C2[3], C2[4], S2[4]);
    FullAdder FA11 (S1[6], XY2[5], C2[4], C2[5], S2[5]);
    FullAdder FA12 (S1[7], XY2[6], C2[5], C2[6], S2[6]);
    FullAdder FA13 (C1[7], XY2[7], C2[6], C2[7], S2[7]);

    // Third Row
    HalfAdder HA4 (S2[1], XY3[0], C3[0], S3[0]);
    FullAdder FA14 (S2[2], XY3[1], C3[0], C3[1], S3[1]);
    FullAdder FA15 (S2[3], XY3[2], C3[1], C3[2], S3[2]);
    FullAdder FA16 (S2[4], XY3[3], C3[2], C3[3], S3[3]);
    FullAdder FA17 (S2[5], XY3[4], C3[3], C3[4], S3[4]);
    FullAdder FA18 (S2[6], XY3[5], C3[4], C3[5], S3[5]);
    FullAdder FA19 (S2[7], XY3[6], C3[5], C3[6], S3[6]);
    FullAdder FA20 (C2[7], XY3[7], C3[6], C3[7], S3[7]);

    // Fourth Row
    HalfAdder HA5 (S3[1], XY4[0], C4[0], S4[0]);
    FullAdder FA21 (S3[2], XY4[1], C4[0], C4[1], S4[1]);
    FullAdder FA22 (S3[3], XY4[2], C4[1], C4[2], S4[2]);
    FullAdder FA23 (S3[4], XY4[3], C4[2], C4[3], S4[3]);
    FullAdder FA24 (S3[5], XY4[4], C4[3], C4[4], S4[4]);
    FullAdder FA25 (S3[6], XY4[5], C4[4], C4[5], S4[5]);
    FullAdder FA26 (S3[7], XY4[6], C4[5], C4[6], S4[6]);
    FullAdder FA27 (C3[7], XY4[7], C4[6], C4[7], S4[7]);

    // Fifth Row
    HalfAdder HA6 (S4[1], XY5[0], C5[0], S5[0]);
    FullAdder FA28 (S4[2], XY5[1], C5[0], C5[1], S5[1]);
    FullAdder FA29 (S4[3], XY5[2], C5[1], C5[2], S5[2]);
    FullAdder FA30 (S4[4], XY5[3], C5[2], C5[3], S5[3]);
    FullAdder FA31 (S4[5], XY5[4], C5[3], C5[4], S5[4]);
    FullAdder FA32 (S4[6], XY5[5], C5[4], C5[5], S5[5]);
    FullAdder FA33 (S4[7], XY5[6], C5[5], C5[6], S5[6]);
    FullAdder FA34 (C4[7], XY5[7], C5[6], C5[7], S5[7]);

    // Sixth Row
    HalfAdder HA7 (S5[1], XY6[0], C6[0], S6[0]);
    FullAdder FA35 (S5[2], XY6[1], C6[0], C6[1], S6[1]);
    FullAdder FA36 (S5[3], XY6[2], C6[1], C6[2], S6[2]);
    FullAdder FA37 (S5[4], XY6[3], C6[2], C6[3], S6[3]);
    FullAdder FA38 (S5[5], XY6[4], C6[3], C6[4], S6[4]);
    FullAdder FA39 (S5[6], XY6[5], C6[4], C6[5], S6[5]);
    FullAdder FA40 (S5[7], XY6[6], C6[5], C6[6], S6[6]);
    FullAdder FA41 (C5[7], XY6[7], C6[6], C6[7], S6[7]);

    // Seventh Row
    HalfAdder HA8 (S6[1], XY7[0], C7[0], S7[0]);
    FullAdder FA42 (S6[2], XY7[1], C7[0], C7[1], S7[1]);
    FullAdder FA43 (S6[3], XY7[2], C7[1], C7[2], S7[2]);
    FullAdder FA44 (S6[4], XY7[3], C7[2], C7[3], S7[3]);
    FullAdder FA45 (S6[5], XY7[4], C7[3], C7[4], S7[4]);
    FullAdder FA46 (S6[6], XY7[5], C7[4], C7[5], S7[5]);
    FullAdder FA47 (S6[7], XY7[6], C7[5], C7[6], S7[6]);
    FullAdder FA48 (C6[7], XY7[7], C7[6], C7[7], S7[7]);

    // Final Product Assignment
    assign P[0] = XYO[0];
    assign P[1] = S1[0];
    assign P[2] = S2[0];
    assign P[3] = S3[0];
    assign P[4] = S4[0];
    assign P[5] = S5[0];
    assign P[6] = S6[0];
    assign P[7] = S7[0];
    assign P[8] = S7[1];
    assign P[9] = S7[2];
    assign P[10] = S7[3];
    assign P[11] = S7[4];
    assign P[12] = S7[5];
    assign P[13] = S7[6];
    assign P[14] = S7[7];
    assign P[15] = C7[7];

endmodule 