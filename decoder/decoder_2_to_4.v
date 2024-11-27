module decoder_2_to_4(
    input [1:0] A,
    input [3:0] Y
);

    wire A0_not, A1_not;
    
    not(A0_not, A[0]);
    not(A1_not, A[1]);
    
    and(Y[0], A1_not, A0_not); // Y0 = ~A1 & ~A0
    and(Y[1], A1_not, A[0]);   // Y1 = ~A1 & A0
    and(Y[2], A[1], A0_not);   // Y2 = A1 & ~A0
    and(Y[3], A[1], A[0]);     // Y3 = A1 & A0

endmodule 