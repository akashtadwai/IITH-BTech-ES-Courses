module full_adder(output wire s, cout, input wire a, b, cin);
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule

module nX1_multiplier (output wire [4:0] z, input wire [3:0] x,u, input wire d, input wire b);

wire [4:0] c;
wire [3:0] t;
assign c[0] = d;
	
	genvar j;
    generate
        for(j = 0; j <=3; j = j + 1)
			begin
				and(t[j], x[j], b);
				full_adder fa1 (z[j], c[j+1], t[j], u[j], c[j]);
            end
    endgenerate
    
assign z[4] = c[4];
endmodule
