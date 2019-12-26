
module cswap(A1, B1, C1, A, B, C);
output A1, B1, C1;
input A, B, C;

assign A1 = A;
assign B1 = (~A&B) | (A&C);
assign C1 = (A&B) | (~A&C);
endmodule
