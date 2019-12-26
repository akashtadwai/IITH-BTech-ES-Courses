//Baudrate = 19200, Parity = None, Stop bits = 1, data bits = 8 (8N1).
module uart #(parameter //for 19200 baud, 8 data bits, 1 stop bit, 2*2 FIFO
    DBIT=8, //data bits
    SB_TICK=16, //ticks for stop bits, 16/24/32 for 1/1.5/2 bits
    DVSR=163, //baud rate divisor, DVSR = 50M/(16*baudrate), baudrate = 19200
    DVSR_BIT=8, //bits of DVSR
    FIFO_W=2) //addr bits of FIFO, 
    (input wire clk, reset, rd_uart, wr_uart, rx, input wire [7:0] w_data,
    output wire tx_full, rx_empty, tx, output wire [7:0] r_data);

    wire tick, rx_done_tick, tx_done_tick, tx_empty, tx_fifo_not_empty;
    wire [7:0] tx_fifo_out, rx_data_out;

    mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) buad_gen_unit 
        (.clk(clk), .reset(reset), .q(), .max_tick(tick));

    fifo #(.B(DBIT), .W(FIFO_W)) fifo_rx_unit (.clk(clk), .reset(reset), .rd(rd_uart),
        .wr(rx_done_tick), .wdata(rx_data_out), .empty(rx_empty), .full(), .rdata(r_data));

    uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit (.clk(clk), .reset(reset),
        .rx(rx), .s_tick(tick), .rx_done_tick(rx_done_tick), .dout(rx_data_out));

    fifo #(.B(DBIT), .W(FIFO_W)) fifo_tx_unit (.clk(clk), .reset(reset), .rd(tx_done_tick),
        .wr(wr_uart), .wdata(w_data), .empty(tx_empty), .full(tx_full), .rdata(tx_fifo_out));

    uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit (.clk(clk), .reset(reset),
        .tx_start(tx_fifo_not_empty), .s_tick(tick), .din(tx_fifo_out), 
        .tx_done_tick(tx_done_tick), .tx(tx));

    assign tx_fifo_not_empty = ~tx_empty;

endmodule

