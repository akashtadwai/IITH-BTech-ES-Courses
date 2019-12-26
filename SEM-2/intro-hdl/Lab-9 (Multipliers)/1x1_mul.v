module full_adder(output wire s, cout, input wire a, b, cin);
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule

module multiplier(output wire g,h, input wire a,b,c,d);
wire t;
and(t,a,b);
full_adder f1(g,h,t,c,d);

endmodule
