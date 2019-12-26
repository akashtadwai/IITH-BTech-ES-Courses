
module regfile #(parameter B=8, W=2)
    (input wire clk, w_en, input wire [W-1:0] waddr, raddr,
    input wire [B-1:0] wdata, rdata);

    reg [B-1:0] reg_array [2**W-1:0];

    always @(posedge clk) 
        if (w_en) reg_array[waddr] <= wdata;

    assign rdata = reg_array[raddr];

endmodule
