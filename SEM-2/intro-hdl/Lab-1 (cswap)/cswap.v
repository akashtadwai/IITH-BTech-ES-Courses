
module cswap(A1, B1, C1, A, B, C);
    output A1, B1, C1;
    input A, B, C;

    wire Ab, B11, B12, C11, C12;
    buf (A1, A);
    not (Ab, A);
    and (B11, Ab, B);
    and (B12, A, C);
    or (B1, B11, B12);
    and (C11, Ab, C);
    and (C12, A, B);
    or (C1, C11, C12);

endmodule
