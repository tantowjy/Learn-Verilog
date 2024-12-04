module FullAdder (
    input XA, 
    input Y, 
    input Cin, 
    output Cout, 
    output Sum

);

    assign Sum = XA ^ Y ^ Cin;
    assign Cout = (XA & Y) | (XA & Cin) | (Y & Cin);

endmodule 