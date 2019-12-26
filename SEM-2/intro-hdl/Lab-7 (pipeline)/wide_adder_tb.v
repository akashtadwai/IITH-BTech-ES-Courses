`timescale 1 ns / 1 ns
module tb;
    reg [15:0] a, b;
    reg clk, cin, reset;
	wire [15:0] sum;
	wire cout;
    initial begin // clock oscillator
        clk = 0;
        forever #10 clk = ~clk;
    end
    initial begin
        $dumpfile("wide_adder.vcd");
        $dumpvars;
    end
    
    adder_16bit u1 (.sum(sum), .cout(cout), .a(a), .b(b), .cin(cin), .clk(clk), .reset(reset)); 

    initial begin // stimulus
reset <= 0;
        @(posedge clk)

a = 16'b0000000000000000; b =16'b0000000000000000; cin=1'b0;
 
        @(posedge clk)
a = 16'b0000000000011101; b=16'b0000000001010101;
        
        @(posedge clk)
a = 16'b0000000001101001; b=16'b0000000000001111; 

        @(posedge clk)
a = 16'b0000000001111001; b=16'b0000000000001111;
	@(posedge clk);
a = 16'b0000000011101001; b=16'b0000001000001111; 

        @(posedge clk)
a = 16'b0000010001111001; b=16'b0000001000001111;
        $finish;
    end
initial $monitor("%t	%0d	%0d	%0d	%0d ",$time,a,b,sum,cout);
endmodule
