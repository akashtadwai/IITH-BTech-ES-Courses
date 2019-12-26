module tb;
    reg clk, A, B, S;
    mux21_1 m(O, A, B, S);

    initial begin // clock oscillator
        clk = 0;
        forever #10 clk = ~clk;
    end
    initial
    begin
        $dumpfile("mux.vcd");
        $dumpvars;
    end
    initial begin
        A = 0;
        B = 1;
        @(posedge clk) S = 1;
        @(posedge clk) $finish; 
	$display clk;
    end
	
endmodule
