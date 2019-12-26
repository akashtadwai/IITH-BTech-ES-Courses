
module tb();
    reg clk, reset, clr, load, en, up;
    reg [2:0] d;
    wire max_tick, min_tick;
    wire [2:0] q;

    counter #(3) dut (clk, rest, clr, load, en, up, d, max_tick, min_tick, q);

    initial
        clk = #10 ~clk;

    initial begin
        reset = 1'b1;
        #(10);
        reset = 1'b0;
    end

    initial begin
        clr = 1'b0;
        load = 1'b0;
        up = 1'b0;
        en = 1'b0;
        d = 3'b000;
        @ (negedge reset);
        @ (negedge clk);
        en = 1'b1;
        up = 1'b1;
        repeat (10) @(negedge clk);
        en = 1'b0;
    end

initial
    begin
        $dumpfile("counter.vcd"); 
        $dumpvars;
    end

endmodule

