
module adder_with_TAP #(parameter BSR_size=14, IR_size=3, size=4) (
    output wire [size-1:0] sum, output wire c_out, TDO,
    input wire [size-1:0] a, b, 
    input wire c_in, TDI, TMS, TCK);

    // Declarations for boundary scan register I/O,
    // this is normally all I/O for the module we are attaching jtag to.
    wire [BSR_size-1:0] BSC_Interface;
    // control lines
    wire reset_bar, selectIR, enableTDO, shiftIR, clockIR, updateIR, shiftDR, clockDR, updateDR, id_update;
    // Test data register serial datapath
    wire test_mode, select_BR, TDR_out; 
    // Captured in S_Capture_IR
    wire [IR_size-1:0] Dummy_data = 3'b101; //idcode	
    wire [IR_size-1:0] instruction;
    wire IR_scan_out; // Instruction register
    wire BSR_scan_out; // Boundary scan register
    wire BR_scan_out; // Bypass register

    //assign TDO = enableTDO ? selectIR ? IR_scan_out:TDR_out:1'bz;
    assign TDO = 1'b1 ? selectIR ? IR_scan_out:TDR_out:1'bz;
    assign TDR_out = select_BR ? BR_scan_out:BSR_scan_out;

    adder M0(.sum(BSC_Interface[13:10]), .c_out(BSC_Interface[9]), .a(BSC_Interface[8:5]),
        .b(BSC_Interface[4:1]), .c_in(BSC_Interface[0]));

    Bypass_Register M1(.scan_out(BR_scan_out), .scan_in(TDI), .shiftDR(shift_BR), .clockDR(clock_BR));
    
    Boundary_Scan_Register M2(.data_out({sum, c_out, BSC_Interface[8:5], BSC_Interface[4:1], BSC_Interface[0]}),
        .data_in({BSC_Interface[13:10], BSC_Interface[9], a, b, c_in}), .scan_out(BSR_scan_out), .scan_in(TDI),
        .shiftDR (shift_BSC_Reg), .mode (test_mode), .clockDR (clock_BSC_Reg), .updateDR (update_BSC_Reg), .id_update(id_update));

    Instruction_Register M3(.data_out(instruction), .data_in(Dummy_data), .scan_out(IR_scan_out),
        .scan_in(TDI), .shiftIR(shiftIR), .clockIR(clockIR), .updateIR(updateIR), .reset_bar(reset_bar));

    Instruction_Decoder M4(.mode(test_mode), .select_BR(select_BR), .shift_BR(shift_BR), .clock_BR(clock_BR), .id_update(id_update),
        .shift_BSC_Reg(shift_BSC_Reg), .clock_BSC_Reg(clock_BSC_Reg), .update_BSC_Reg(update_BSC_Reg),
        .instruction (instruction), .shiftDR(shiftDR), .clockDR(clockDR), .updateDR(updateDR));

    TAP_Controller M5(.reset_bar(reset_bar), .selectIR(selectIR), .shiftIR(shiftIR), .clockIR(clockIR),
        .updateIR(updateIR), .shiftDR(shiftDR), .clockDR(clockDR), .updateDR(updateDR), .enableTDO(enableTDO),
        .TMS(TMS), .TCK(TCK));
endmodule

module adder #(parameter size=4) (output wire [size-1:0] sum, output wire c_out, 
    input wire [size-1:0] a, b, input wire c_in);
  assign {c_out, sum} = a + b + c_in;
endmodule

