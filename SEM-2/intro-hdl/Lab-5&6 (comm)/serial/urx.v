module uart_rx #(parameter DBIT=8, SB_TICK=16) 
    (input wire clk, reset, rx, s_tick, output wire [DBIT-1:0] dout, output reg rx_done_tick);

    localparam [1:0]
        idle = 2'b00,
        start= 2'b01,
        data = 2'b10,
        stop = 2'b11;

    reg [1:0] state_reg, state_next;
    reg [3:0] s_reg, s_next;
    reg [2:0] n_reg, n_next;
    reg [7:0] b_reg, b_next;

    always @(posedge clk, posedge reset)
        if (reset) {state_reg, s_reg, n_reg, b_reg} <= {idle, 4'b0, 3'b0, 8'b0};
        else {state_reg, s_reg, n_reg, b_reg} <= {state_next, s_next, n_next, b_next};

    always @(*) begin
        rx_done_tick = 1'b0;
        {state_next, s_next, n_next, b_next} = {state_reg, s_reg, n_reg, b_reg};
        case (state_reg)
            idle: if (~rx) {state_next, s_next} = {start, 4'b0};
            start: 
                if (s_tick) 
                    if (s_reg==7) {state_next, s_next, n_next} = {data, 4'b0, 3'b0};
                    else s_next = s_reg + 1;
            data:
                if (s_tick)
                    if (s_reg==15) begin
                        s_next = 0;
                        b_next = {rx, b_reg[7:1]};
                        if (n_reg==(DBIT-1)) state_next = stop;
                        else n_next = n_reg + 1;
                    end
                    else s_next = s_reg + 1;
            stop:
                if (s_tick)
                    if (s_reg==(SB_TICK-1)) {state_next, rx_done_tick} = {idle, 1'b1};
                    else s_next = s_reg + 1;
        endcase
    end
    assign dout = b_reg;
endmodule

