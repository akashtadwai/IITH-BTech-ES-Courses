module FA (s, co, a, b, cin);
    output s, co;
    input a, b, cin;

    assign {!co, !s} = !(a + b + cin);
endmodule
