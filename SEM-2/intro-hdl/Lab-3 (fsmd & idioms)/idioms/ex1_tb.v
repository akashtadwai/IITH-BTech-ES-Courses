module tb;
    reg a, b, clk, rst_n;
    initial begin // clock oscillator
        clk = 0;
        forever #10 clk = ~clk;
    end
    initial begin
        $dumpfile("ex1.vcd");
        $dumpvars;
    end
    
    sblk1 u1 (.q2(q2), .a(a), .b(b), .clk(clk), .rst_n(rst_n));


    initial begin // stimulus
        a = 0; b = 0;
        rst_n <= 0;
        @(posedge clk);
        @(negedge clk) rst_n = 1;
        a = 1; b = 1;
        @(negedge clk) a = 0;
        @(negedge clk) b = 0;
        @(negedge clk) $finish;
    end
initial $monitor("%0d",a);
endmodule
