module rd #(parameter n=8, p=8) (output wire [p-1:0] quotient, remainder, output wire done,
    input wire [n-1:0] x, y, input wire clk, reset, start);
    reg [p-1:0] q, r, rnext;
    integer z, count;
    reg qbit, done_tick;

    assign quotient = q;
    assign remainder = r;
    assign done = done_tick;

    always @(posedge clk, posedge reset) begin
      if (reset) begin count = 0; done_tick = 1'b0; qbit = 1'b0; q = 0; r = 0; end
      else if (start) begin rnext = x; count = 1; end
      else if (count>0) begin
        r = rnext;
        qbit = 1'b0;
        z = 2*r - y;
        if (z<0) begin qbit = 1'b0; rnext = 2*r; end
        else begin qbit = 1'b1; rnext = z; end
        q = {q[p-2:0], qbit};
        count = count + 1;
        if (count==p+1) begin count=0; done_tick = 1'b1; end
      end
    end
endmodule
