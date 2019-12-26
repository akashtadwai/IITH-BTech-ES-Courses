module sumprod(a, b, c, sum, prod);
input [1:0] a, b, c;
output [1:0] sum, prod;
{* sumstuff *}
assign sum = a + b + c;
{* *}
assign prod = a * b * c;
endmodule
