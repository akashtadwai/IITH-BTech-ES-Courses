
module reduce_moore (input wire clk, reset, in, output reg out);
    reg [1:0] curr, next;

    localparam 
        zero = 2'b00,
        one  = 2'b01,
        two1 = 2'b11;

    always @ (posedge clk) begin
        if(reset) curr <= zero;
        else curr <= next;
    end

    always @(*) begin //in or curr
        next = curr;
        out = 1'b0;
        case (curr)
            zero: if (in) next = one;
            one: 
                if (in) next = two1;
                else next = zero;
            two1: begin
                out = 1'b1;
                if (~in) next = zero;
            end
        endcase
    end
endmodule


module reduce_mealy (input wire clk, reset, in, output reg out);
    reg curr, next;

    localparam zero = 1'b0, one  = 1'b1;

    always @ (posedge clk) begin
        if(reset) curr <= zero;
        else curr <= next;
    end

    always @(*) begin //in or curr
        next = curr;
        out = 1'b0;
        case (curr)
            zero: if (in) next = one;
            one: begin
                if (in) next = one;
                else next = zero;
                out = in;
            end
        endcase
    end
endmodule
