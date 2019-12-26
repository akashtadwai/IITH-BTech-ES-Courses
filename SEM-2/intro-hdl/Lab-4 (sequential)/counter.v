
module counter_sm (output reg [1:0] q, input wire clk);
    reg [1:0] p;

    always @(q)
        case (q)
            2'b00: p = 2'b01;
            2'b01: p = 2'b10;
            2'b10: p = 2'b11;
            2'b11: p = 2'b00;
        endcase

    always @(posedge clk)
        q <= p;
endmodule
module counter #(parameter N=8)
    (input wire clk, reset, clr, load, en, up,
    input wire [N-1:0] d,
    output wire max_tick, min_tick,
    output wire [N-1:0] q);

    reg [N-1:0] regs, next; 

    always @(posedge clk, posedge reset)
        if (reset) regs <= 0;
        else regs <= next;

    //next state logic,
    always @(*)
        if (clr) next =0;
        else if (load) next = d;
        else if (en & up) next = regs + 1;
        else if (en & ~up) next = regs - 1;
        else next = regs;

    assign q = regs;
    assign max_tick = (regs == 2**N -1)? 1'b1: 1'b0;
    assign min_tick = (regs == 0)? 1'b1: 1'b0;
endmodule

