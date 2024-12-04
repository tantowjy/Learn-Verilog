module HalfAdder (
    input XA,
    input Y,
    output Cout,
    output Sum
);

    assign Sum = XA ^ Y; 
    assign Cout = XA & Y;

endmodule 