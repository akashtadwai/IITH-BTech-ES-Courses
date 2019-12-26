module ex1(input clk, a, b, c, output reg [1:0] y);

    always @(posedge clk)
    if (c)
        y <= a+b;
endmodule
