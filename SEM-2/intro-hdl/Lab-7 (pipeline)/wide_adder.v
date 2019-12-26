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
    reg [7:0] ifa, ifb;
    wire [7:0] ifanextw, ifbnextw;
    reg if2;
    wire if2nextw;
    reg [7:0] if3;
    wire [7:0] if3nextw;
    wire [3:0] carry;

    wide_adder w1(if3nextw[3:0], carry[0], a[3:0], b[3:0], cin);
    wide_adder w2(if3nextw[7:4], if2nextw, a[7:4], b[7:4], carry[0]);
    wide_adder w3(sum[11:8], carry[2], ifa[3:0], ifb[3:0], if2);
    wide_adder w4(sum[15:12], carry[3], ifa[7:4], ifb[7:4], carry[2]);

    always @(posedge clk, reset) begin
        if (reset) begin
            {ifa, ifb, if2, if3} <= {4'b0, 4'b0, 1'b0, 4'b0};
        end
        else begin
            ifa <= ifanextw;
            ifb <= ifbnextw;
            if2 <= if2nextw;
            if3 <= if3nextw;
        end
    end

    assign sum[7:0] = if3;
    assign {ifanextw, ifbnextw} = {a[15:8], b[15:8]};
    assign cout = carry[3];
endmodule

