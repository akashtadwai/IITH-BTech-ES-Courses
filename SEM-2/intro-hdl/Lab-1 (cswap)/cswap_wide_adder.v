
module cswap(A1, B1, C1, A, B, C);
    output A1, B1, C1;
    input A, B, C;

    wire Ab, B11, B12, C11, C12;
    buf (A1, A);
    not (Ab, A);
    and (B11, Ab, B);
    and (B12, A, C);
    or (B1, B11, B12);
    and (C11, Ab, C);
    and (C12, A, B);
    or (C1, C11, C12);

endmodule

module cswap_fa(s, cout, a, b, cin);
    output s, cout;
    input a, b, cin;
    
    wire i1, i2, i3;
    wire j1, j2, j3;
    wire k1, k2, k3;
    wire l1, l2, l3;
    wire m1, m2, m3;
    cswap g1(i1, i2, i3, a, 1'b0, 1'b1);
    cswap g2(j1, j2, j3, b, i2, i3);
    cswap g3(k1, k2, k3, cin, j2, j3);
    cswap g4(s, l2, l3, k2, k1, k3);
    cswap g5(m1, cout, m3, j1, l2, l3);
endmodule
        
module cswap_wide_adder #(parameter [3:0] width = 4) (s, cout, a, b, cin);
    output [width-1:0] s;
    output cout;
    input [width-1:0] a, b;
    input cin;

    wire [width:0] c;
    assign c[0] = cin;
    assign cout = c[width];

    genvar n;
    generate
        for(n=0; n<width; n=n+1)
            cswap_fa fa(s[n], c[n+1], a[n], b[n], c[n]);
    endgenerate
endmodule
