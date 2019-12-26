module dff_en (input wire clk, reset, en, output wire d, output reg q);
    always @ (posedge clk, posedge reset)
        if (reset) q <= 1'b0;
        else if (en) q <= d;
endmodule

module tb;
	reg clk =0, reset=0, en = 1;
	wire q;
	reg d = 0;
	always #1 clk = !clk;
	always #2 reset = !reset;
	always #2 en = !en;
	always #1 d = !d;

initial
    begin
        $dumpfile("dff.vcd"); 
        $dumpvars;
    end
endmodule
	


