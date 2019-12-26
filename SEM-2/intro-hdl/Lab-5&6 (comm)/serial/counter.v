
module mod_m_counter #(parameter N=4, M=10) (input wire clk, reset,
    output wire max_tick, output wire [N-1:0] q);

    reg [N-1:0] r_reg;
    wire [N-1:0] r_next;
    
    always @(posedge clk, posedge reset) 
        if (reset) r_reg <= 0;
        else r_reg <= r_next;

    assign r_next = (r_reg==(M-1))? 0: r_reg + 1;
    assign q = r_reg;
    assign max_tick = (r_reg == (M-1))? 1'b1: 1'b0;
endmodule

