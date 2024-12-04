module multiplier_array_4bit (
    input[3:0] XA,
    input[3:0] Y,
    output [7:0] P
);

    wire[3:0] C1;
    wire[3:0] C2;
    wire[3:0] C3;
    wire[3:0] S1;
    wire[3:0] S2;
    wire[3:0] S3;
    wire[3:0] XYO;
    wire[3:0] XY1;
    wire[3:0] XY2; 
    wire[3:0] XY3;

    assign XYO[0] = XA[0] & Y[0]; 
    assign XY1[0] = XA[0] & Y[1]; 
    assign XY2[0] = XA[0] & Y[2]; 
    assign XY3[0] = XA[0] & Y[3];

    assign XYO[1] = XA[1] & Y[0]; 
    assign XY1[1] = XA[1] & Y[1]; 
    assign XY2[1] = XA[1] & Y[2]; 
    assign XY3[1] = XA[1] & Y[3]; 

    assign XYO[2] = XA[2] & Y[0]; 
    assign XY1[2] = XA[2] & Y[1]; 
    assign XY2[2] = XA[2] & Y[2]; 
    assign XY3[2] = XA[2] & Y[3]; 

    assign XYO[3] = XA[3] & Y[0]; 
    assign XY1[3] = XA[3] & Y[1]; 
    assign XY2[3] = XA[3] & Y[2]; 
    assign XY3[3] = XA[3] & Y[3];

    HalfAdder HA1 (XYO[1], XY1[0], C1[0], S1[0]);
    HalfAdder HA2 (XY1[3], C1[2], C1[3], S1[3]); 
    HalfAdder HA3 (S1[1], XY2[0], C2[0], S2[0]); 
    HalfAdder HA4 (S2[1], XY3[0], C3[0], S3[0]);

    FullAdder FA1 (XYO[2], XY1[1], C1[0], C1[1], S1[1]); 
    FullAdder FA2 (XYO[3], XY1[2], C1[1], C1[2], S1[2]); 
    FullAdder FA3 (S1[2], XY2[1], C2[0], C2[1], S2[1]); 
    FullAdder FA4 (S1[3], XY2[2], C2[1], C2[2], S2[2]); 
    FullAdder FA5 (C1[3], XY2[3], C2[2], C2[3], S2[3]); 
    FullAdder FA6 (S2[2], XY3[1], C3[0], C3[1], S3[1]); 
    FullAdder FA7 (S2[3], XY3[2], C3[1], C3[2], S3[2]); 
    FullAdder FA8 (C2[3], XY3[3], C3[2], C3[3], S3[3]); 

    assign P[0] = XYO[0];
    assign P[1] = S1[0];
    assign P[2] = S2[0];
    assign P[3] = S3[0];
    assign P[4] = S3[1];
    assign P[5] = S3[2];
    assign P[6] = S3[3];
    assign P[7] = C3[3];

endmodule 