
module uart_tx #(parameter DBIT=8, SB_TICK=16) 
    (input wire clk, reset, tx_start, s_tick, input wire [DBIT-1:0] din, 
        output reg tx_done_tick, output wire tx);

    localparam [1:0]
        idle = 2'b00,
        start= 2'b01,
        data = 2'b10,
        stop = 2'b11;

    reg [1:0] state_reg, state_next;
    reg [3:0] s_reg, s_next;
    reg [2:0] n_reg, n_next;
    reg [7:0] b_reg, b_next;
    reg tx_reg, tx_next;

    always @(posedge clk, posedge reset)
        if (reset) {state_reg, s_reg, n_reg, b_reg, tx_reg} <= {idle, 1'b0, 1'b0, 1'b0, 1'b1};
        else {state_reg, s_reg, n_reg, b_reg, tx_reg} <= {state_next, s_next, n_next, b_next, tx_next};

    always @(*) begin
        {state_next, tx_done_tick, s_next, n_next, b_next, tx_next} = {state_reg, 1'b0, s_reg, n_reg, b_reg, tx_reg};
        case (state_reg)
            idle: begin
                tx_next = 1'b1;
                if (tx_start) {state_next, s_next, b_next} = {start, 4'b0000, din};
            end
            start: begin
                tx_next = 1'b0;
                if (s_tick) 
                    if (s_reg == 15) begin
                        {state_next, s_next, n_next} = {data, 4'b0000, 3'b000};
                        end
                    else s_next = s_reg + 1;
                end
            data: begin
                tx_next = b_reg[0];
                if (s_tick)
                    if (s_reg==15) begin
                        s_next = 0;
                        b_next = b_reg >> 1;
                        if (n_reg==(DBIT-1)) state_next = stop;
                        else n_next = n_reg + 1;
                    end
                    else s_next = s_reg + 1;
                end
            stop: begin
                tx_next = 1'b1;
                if (s_tick)
                    if (s_reg==(SB_TICK-1)) begin
                        state_next = idle;
                        tx_done_tick = 1'b1;
                    end
                    else s_next = s_reg + 1;
                end
        endcase
    end
    assign tx = tx_reg;
endmodule

