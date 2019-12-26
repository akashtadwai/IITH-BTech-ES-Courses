module sblk1 (output reg q2, input a, b, clk, rst_n);
    reg q1, d1, d2;
    
    always @(a or b or q1) begin
        d1 = a & b;
        d2 = d1 | q1;
    end

    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            q2 <= 0;
            q1 <= 0;
        end
        else begin
            q2 <= d2;
            q1 <= d1;
        end
endmodule
