module FA (s, co, a, b, cin);
    output s, co;
    input a, b, cin;

    wire w1,w2,w3,w4,w5,w6,w7;
    nand n1(w1,a,b);
    nand n2(w3,a,w1);
    nand n3(w2,w1,b);
    nand n4(w4,w3,w2);
    nand n5(w5,w4,cin);
    nand n6(w6,w4,w5);
    nand n7(w7,w5,cin);
    nand n8(co,w5,w1);
    nand n9(s,w6,w7);
endmodule
