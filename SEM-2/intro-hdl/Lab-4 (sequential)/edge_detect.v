
module edge_moore (input wire clk, reset, level, output reg tick);
    localparam [1:0]
        zero = 2'b00,
        edg  = 2'b01,
        one  = 2'b10;

    reg [1:0] curr, next;

    always @(posedge clk, posedge reset)
        if (reset) curr <= zero;
        else curr <= next;

    always @(*) begin
        next = curr;
        tick = 1'b0;
        case (curr)
            zero: if (level) next = edg;
            edg : 
                begin
                    tick = 1'b1;
                    if(level) next = one;
                    else next = zero;
                end
            one: if (~level) next = zero;
            default: next = zero;
        endcase
    end
endmodule

module edge_mealy (input wire clk, reset, level, output reg tick);
    localparam [1:0]
        zero = 2'b00,
        one  = 2'b10;

    reg [1:0] curr, next;

    always @(posedge clk, posedge reset)
        if (reset) curr <= zero;
        else curr <= next;

    always @(*) begin
        next = curr;
        tick = 1'b0;
        case (curr)
            zero:
                if (level) begin
                    tick = 1'b1;
                    next = one;
                end
            one:
                if (~level) next = zero;
            default: next = zero;
        endcase
    end
endmodule

module edge_direct (input wire clk, reset, level, output wire tick);
    reg delay;

    always @(posedge clk, posedge reset)
        if (reset) delay <= 1'b0;
        else delay <= level;
    
    assign tick = ~delay & level;
endmodule


