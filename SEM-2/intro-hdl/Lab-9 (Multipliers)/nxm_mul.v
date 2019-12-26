module full_adder(output wire s, cout, input wire a, b, cin);
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule

module nX1_mul (output wire [4:0] z, input wire [3:0] x,u, input wire d, input wire b);

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

module nXm_mul (output wire [6:0] s,input wire [3:0] x,u, input wire [2:0] y,v, input wire clk,reset);
	wire [4:0] c;
	wire [4:0] b1,b2;
	wire [3:0] a1,a2,a3;

	
	assign a1 = u;
	nX1_mul m0(b1,x,a1,v[0],y[0]);
	assign s[0] = b1[0];
	
	assign a2 = b1[4:1];
	nX1_mul m1(b2,x,a2,v[1],y[1]);
	assign s[1] = b2[0];
	
	assign a3 = b2[4:1];
	nX1_mul m2(s[6:2],x,a3,v[2],y[2]);

endmodule
