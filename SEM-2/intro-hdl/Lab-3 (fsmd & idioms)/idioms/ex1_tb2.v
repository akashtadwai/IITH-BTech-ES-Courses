module tb;
    reg a, b, clk, rst_n;
    initial begin // clock oscillator
        clk = 0;
        forever #10 clk <= ~clk;
    end
    initial begin
        $dumpfile("ex1.vcd");
        $dumpvars;
    end
    
    sblk1 u1 (.q2(q2), .a(a), .b(b), .clk(clk), .rst_n(rst_n));



    initial begin // stimulus
        a = 1; b = 0;
	a<=b;
	b<=a;
	 $finish;
    end
	 initial $monitor("%0d ", clk);

endmodule
