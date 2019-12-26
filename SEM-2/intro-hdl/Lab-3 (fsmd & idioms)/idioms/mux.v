
module mux21_1 (output o, input a, b, sel);
    wire o = sel? a:b;
endmodule

module mux21_2 (output o, input a, b, sel);
    reg o;
    always @(*)
        if (sel) o = a;
        else o = b;
endmodule

module mux41_1 (output o, input a, b, c, d, input [1:0] s);
    reg o;
    always @(a, b, c, d, s) begin
        if (s==2'b00) o = a;
        else if (s==2'b01) o = b;
        else if (s==2'b10) o = c;
        else o = d;
    end
    /*
    always @(a, b, c, d, s) begin
        if (s[1]==1'b0)
            if (s[0]==1'b0) o = a;
            else o = b;
        else
            if (s[0]==1'b0) o = c;
            else o = d;
    end
    */
endmodule

module mux41_2 (output o, input a, b, c, d, input [1:0] s);
    reg o;
    always @(a, b, c, d, s) begin
        case (s)
            2'b00: o = a;
            2'b01: o = b;
            2'b10: o = c;
            2'b11: o = d;
            //default: o = a;
        endcase
    end
endmodule

module mux81_1 (output o, input a, b, c, d, e, f, g, h, input [3:0] s);
    reg o;
    always @(a, b, c, d, e, f, g, h, s) begin
        case (s)
            0: o = a;
            1: o = b;
            2: o = c;
            3: o = d;
            4: o = e;
            5: o = f;
            6: o = g;
            7: o = h;
            default: o = a;
        endcase
    end
endmodule

