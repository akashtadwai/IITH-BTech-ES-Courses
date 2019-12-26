module cswap(A1, B1, C1, A, B, C);
output A1, B1, C1;
input A, B, C;

reg A1;
reg B1, C1;

always @(A or B or C)
    if (A)
    begin
        A1 <= A;
        B1 <= C;
        C1 <= B;
    end
    else
    begin
        A1 <= A;
        B1 <= B;
        C1 <= C;
    end
endmodule
