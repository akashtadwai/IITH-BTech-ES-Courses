
module alu (output [7:0] o, input [3:0] sel, input [7:0] a, b, input cin);
    
    reg [7:0] o;
    reg [7:0] arith_unit, logic_unit, noshift;
    reg [2:0] x;

    always @(sel, a, b, cin) begin: alu_proc
        case (sel[1:0])
            2'b00: logic_unit = a & b;
            2'b01: logic_unit = a | b;
            2'b10: logic_unit = a ^ b;
            2'b11: logic_unit = !a;
            default: logic_unit = 8'bX;
        endcase
        
        x = {sel[1:0],cin};
        case (x)
            3'b000: arith_unit = a;
            3'b001: arith_unit = a + 1;
            3'b010: arith_unit = a + b;
            3'b011: arith_unit = a + b + 1;
            3'b100: arith_unit = a + !b;
            3'b101: arith_unit = a - b;
            3'b110: arith_unit = a - 1;
            3'b111: arith_unit = a;
            default: arith_unit = 8'bX;
        endcase

        if(sel[2]) noshift = logic_unit;
        else noshift = arith_unit;

        case (sel[4:3])
            2'b00: o = noshift;
            2'b01: o = noshift << 1;
            2'b00: o = noshift >> 1;
            2'b00: o = 8'b0;
            2'b00: o = 8'bX;
        endcase
    end

endmodule
