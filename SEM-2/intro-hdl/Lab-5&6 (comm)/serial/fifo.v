
module fifo #(parameter B=8, W=4)
    (input wire clk, reset, rd, wr,
    input wire [B-1:0] wdata,
    output wire empty, full,
    output wire [B-1:0] rdata);
    
    reg [B-1:0] array [2**W-1:0];
    reg [W-1:0] wcurr, wnext, wsucc;
    reg [W-1:0] rcurr, rnext, rsucc;
    
    reg full_reg, empty_reg, full_next, empty_next;
    wire wen;

    always @(posedge clk)
        if (wen) array[wcurr] <= wdata;

    assign rdata = array[rcurr];
    assign wen = wr & ~full_reg;

    always @(posedge clk, posedge reset)
        if (reset) begin
            wcurr <= 0;
            rcurr <= 0;
            full_reg <= 1'b0;
            empty_reg <= 1'b1;
        end
        else begin
            wcurr <= wnext;
            rcurr <= rnext;
            full_reg <= full_next;
            empty_reg <= empty_next;
        end


    always @(*) begin
        wsucc = wcurr + 1;
        rsucc = rcurr + 1;
        wnext = wcurr;
        rnext = rcurr;
        full_next = full_reg;
        empty_next = empty_reg;
        case ({wr, rd})
            2'b01: 
                if (~empty_reg) begin
                    rnext = rsucc;
                    full_next = 1'b0;
                    if (rsucc == wcurr) empty_next = 1'b1;
                end
            2'b10: 
                if (~full_reg) begin
                    wnext = wsucc;
                    empty_next = 1'b0;
                    if (wsucc == rcurr) full_next = 1'b1;
                end
            2'b11: 
                begin
                    wnext = wsucc;
                    rnext = rsucc;
                end
        endcase
    end

    assign full = full_reg;
    assign empty = empty_reg;
endmodule


