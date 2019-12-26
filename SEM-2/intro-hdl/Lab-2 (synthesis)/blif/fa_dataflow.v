module FA (s, co, a, b, cin);
    output s, co;
    input a, b, cin;

    assign co = a&b | b&cin | a&cin;
    assign s = a ^ b ^ cin;
endmodule
