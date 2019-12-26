module uart_TAP #(parameter BSR_size=22, IR_size=3, size=4)
    (input wire TDI, TMS, TCK, clk, reset, rd_uart, wr_uart, rx, input wire [7:0] w_data,
        output wire TDO, tx_full, rx_empty, tx, output wire [7:0] r_data);

    // Declarations for boundary scan register I/O,
    // this is normally all I/O for the module we are attaching jtag to.
    wire [BSR_size-1:0] BSC_Interface;
    // control lines
    wire reset_bar, selectIR, enableTDO, shiftIR, clockIR, updateIR, shiftDR, clockDR, updateDR;
    // Test data register serial datapath
    wire test_mode, select_BR, TDR_out; 
    // Captured in S_Capture_IR
    wire [IR_size-1:0] Dummy_data = 3'b001;	
    wire [IR_size-1:0] instruction;
    wire IR_scan_out; // Instruction register
    wire BSR_scan_out; // Boundary scan register
    wire BR_scan_out; // Bypass register

    assign TDO = enableTDO ? selectIR ? IR_scan_out:TDR_out:1'bz;
    assign TDR_out = select_BR ? BR_scan_out:BSR_scan_out;

    uart uart1 (.clk(clk), .reset(reset), .rd_uart(BSC_Interface[0]), .wr_uart(BSC_Interface[1]),
        .rx(BSC_Interface[2]), .w_data(BSC_Interface[10:3]), .tx_full(BSC_Interface[11]), 
        .rx_empty(BSC_Interface[12]), .tx(BSC_Interface[13]), .r_data(BSC_Interface[21:14]));

    Bypass_Register M1(.scan_out(BR_scan_out), .scan_in(TDI), .shiftDR(shift_BR), .clockDR(clock_BR));
    
    Boundary_Scan_Register #(.size(BSR_size)) M2(.data_out({r_data, tx, rx_empty, tx_full, BSC_Interface[10:3], 
        BSC_Interface[2], BSC_Interface[1], BSC_Interface[0]}), .data_in({BSC_Interface[21:14], BSC_Interface[13],
        BSC_Interface[12], BSC_Interface[11], w_data, rx, wr_uart, rd_uart}), .scan_out(BSR_scan_out), .scan_in(TDI),
        .shiftDR(shift_BSC_Reg), .mode(test_mode), .clockDR(clock_BSC_Reg), .updateDR(update_BSC_Reg));

    Instruction_Register M3(.data_out(instruction), .data_in(Dummy_data), .scan_out(IR_scan_out),
        .scan_in(TDI), .shiftIR(shiftIR), .clockIR(clockIR), .updateIR(updateIR), .reset_bar(reset_bar));

    Instruction_Decoder M4(.mode(test_mode), .select_BR(select_BR), .shift_BR(shift_BR), .clock_BR(clock_BR),
        .shift_BSC_Reg(shift_BSC_Reg), .clock_BSC_Reg(clock_BSC_Reg), .update_BSC_Reg(update_BSC_Reg),
        .instruction(instruction), .shiftDR(shiftDR), .clockDR(clockDR), .updateDR(updateDR));

    TAP_Controller M5(.reset_bar(reset_bar), .selectIR(selectIR), .shiftIR(shiftIR), .clockIR(clockIR),
        .updateIR(updateIR), .shiftDR(shiftDR), .clockDR(clockDR), .updateDR(updateDR), .enableTDO(enableTDO),
        .TMS(TMS), .TCK(TCK));
endmodule
