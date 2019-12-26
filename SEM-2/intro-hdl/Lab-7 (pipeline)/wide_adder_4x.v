module fa(output wire s, cout, input wire a, b, cin);
    assign {cout, s} = cin + a + b;
endmodule

module wide_adder #(parameter [3:0] width = 4) (output wire [width-1:0] s, 
    output wire cout, input wire [width-1:0] a, b, input wire cin);

    wire [width:0] c;
    assign c[0] = cin;
    assign cout = c[width];

    genvar n;
    generate
        for(n=0; n<width; n=n+1)
            fa fa(s[n], c[n+1], a[n], b[n], c[n]);
    endgenerate
endmodule


module adder_16bit(output wire [15:0] sum, output wire cout, input wire [15:0] a, b, 
    input wire cin, clk, reset);
    reg [3:0] a22, b22, a32, b32, a33, b33, a42, b42, a43, b43, a44, b44, o12, o13, o14, o22, o23, o32;
    wire [3:0] a21, b21, a31, b31, a41, b41, o11, o21, o31;
    reg c2i, c3i, c4i;
    wire c1o, c2o, c3o;


    wide_adder w1(o11, c1o, a[3:0], b[3:0], cin);
    wide_adder w2(o21, c2o, a22, b22, c2i);
    wide_adder w3(o31, c3o, a33, b33, c3i);
    wide_adder w4(sum[15:12], cout, a44, b44, c4i);

    always @(posedge clk, reset) begin
        if (reset) begin
            {a22, b22, a32, b32, a33, b33, a42, b42, a43, b43, a44, b44, o12, o13, o14, o22, o23, o32, c2i, c3i, c4i} <= {4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 4'b0, 1'b0, 1'b0, 1'b0};
        end
        else begin
			a22 <= a21;
			b22 <= b21;
			a32 <= a31;
			b32 <= b31;
			a33 <= a32;
			b33 <= b32;
			a42 <= a41;
			b42 <= b41;
			a43 <= a42;
			b43 <= b42;
			a44 <= a43;
			b44 <= b43;

			c2i <= c1o;
			c3i <= c2o;
			c4i <= c3o;
			
			o12 <= o11;
			o13 <= o12;
			o14 <= o13;
			o22 <= o21;
			o23 <= o22;
			o32 <= o31;
			
        end
    end

    assign sum[3:0] = o14;
    assign sum[7:4] = o23;
    assign sum[11:8] = o32;
    
    assign {a21, b21} = {a[7:4], b[7:4]};
    assign {a31, b31} = {a[11:8], b[11:8]};
    assign {a41, b41} = {a[15:12], b[15:12]};
    
    
endmodule
