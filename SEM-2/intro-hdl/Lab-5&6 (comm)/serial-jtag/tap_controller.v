module TAP_Controller (output reg reset_bar, selectIR, shiftIR, shiftDR, enableTDO,
    output wire clockIR, updateIR, clockDR, updateDR, input TMS, TCK); 
  
    localparam 
        S_Reset = 0, S_Run_Idle = 1, S_Select_DR = 2, S_Capture_DR = 3,
        S_Shift_DR = 4, S_Exit1_DR = 5, S_Pause_DR = 6, S_Exit2_DR = 7,
        S_Update_DR = 8, S_Select_IR = 9, S_Capture_IR = 10, S_Shift_IR = 11, 
        S_Exit1_IR = 12, S_Pause_IR = 13, S_Exit2_IR = 14, S_Update_IR = 15; 
 
    reg [3:0] state, next_state; 
    
    always @(negedge TCK) 
        reset_bar <= (state == S_Reset) ? 0:1;// Registered active low  
    always @ (negedge TCK) begin 
        shiftDR <= (state == S_Shift_DR) ? 1:0;// Registered select for scan mode 
        shiftIR <= (state == S_Shift_IR) ? 1:0; 
        // Registered output enable 
        enableTDO <= ((state == S_Shift_DR) || (state == S_Shift_IR)) ? 1:0;
    end 
 
    //  Gated clocks for capture registers  
    assign clockDR = !(((state == S_Capture_DR) || (state == S_Shift_DR)) && (TCK == 0)); 
    assign clockIR = !(((state == S_Capture_IR) || (state == S_Shift_IR)) && (TCK == 0));

    // Gated clocks for output registers 
    assign updateDR = (state == S_Update_DR) && (TCK == 0); 
    assign updateIR = (state == S_Update_IR) && (TCK == 0); 
  
    always @(posedge TCK) state <= next_state; 

    always @ (state or TMS) begin 
        selectIR = 0; 
        next_state = state; 
        case (state)
            S_Reset: begin selectIR = 1; if (TMS==0) next_state = S_Run_Idle; end
            S_Run_Idle: begin selectIR = 1; if (TMS) next_state = S_Select_DR; end
            S_Select_DR: next_state = TMS ? S_Select_IR:S_Capture_DR; 
            S_Capture_DR: begin next_state = TMS ? S_Exit1_DR: S_Shift_DR; end
            S_Shift_DR: if (TMS) next_state = S_Exit1_DR;
            S_Exit1_DR: next_state = TMS ? S_Update_DR: S_Pause_DR;
            S_Pause_DR: if (TMS) next_state = S_Exit2_DR;
            S_Exit2_DR: next_state = TMS ? S_Update_DR: S_Shift_DR;
            S_Update_DR: begin next_state = TMS ? S_Select_DR: S_Run_Idle; end
            S_Select_IR: begin next_state = TMS ? S_Reset: S_Capture_IR; end 
            S_Capture_IR: begin selectIR = 1; next_state = TMS ? S_Exit1_IR: S_Shift_IR; end 
            S_Shift_IR: begin selectIR = 1; if (TMS) next_state = S_Exit1_IR; end
            S_Exit1_IR: begin selectIR = 1; next_state = TMS ? S_Update_IR: S_Pause_IR; end 
            S_Pause_IR: begin selectIR = 1; if (TMS) next_state = S_Exit2_IR; end
            S_Exit2_IR: begin  selectIR = 1; next_state = TMS ? S_Update_IR: S_Shift_IR; end 
            S_Update_IR: begin selectIR = 1;  next_state = TMS ? S_Select_DR: S_Run_Idle; end 
            default: next_state = S_Reset;
        endcase
    end 
endmodule 
 
 
module Instruction_Decoder #(parameter IR_size=3) (
    output reg mode, select_BR, clock_BR, clock_BSC_Reg, update_BSC_Reg, 
    output wire shift_BR, shift_BSC_Reg, 
    input [IR_size-1:0] instruction, input shiftDR, clockDR, updateDR); 
    
    localparam BYPASS = 3'b111, EXTEST = 3'b000, SAMPLE_PRELOAD = 3'b010, INTEST = 3'b011,
        RUNBIST = 3'b100, IDCODE = 3'b101; 
    
    assign shift_BR = shiftDR;
    assign shift_BSC_Reg = shiftDR; 
 
    always @(instruction or clockDR or updateDR) begin
        {mode, select_BR, clock_BR, clock_BSC_Reg, update_BSC_Reg} = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0};
        case (instruction) 
            EXTEST: begin mode = 1; clock_BSC_Reg = clockDR; update_BSC_Reg = updateDR; end
            INTEST: begin mode = 1; clock_BSC_Reg = clockDR; update_BSC_Reg = updateDR; end
            SAMPLE_PRELOAD: begin clock_BSC_Reg = clockDR; update_BSC_Reg = updateDR; end
            RUNBIST: begin  end
            IDCODE: begin select_BR = 1; clock_BR = clockDR;  end
            BYPASS: begin select_BR = 1; clock_BR = clockDR; end // 1 selects bypass reg 
            default: begin select_BR = 1; end // 1 selects bypass reg
        endcase
    end
endmodule 


module Instruction_Register #(parameter IR_size=3) (
    output wire [IR_size-1:0] data_out, output wire scan_out,
    input wire [IR_size-1:0] data_in, 
    input wire scan_in, shiftIR, clockIR, updateIR, reset_bar); 
    
    reg [IR_size-1:0] IR_Scan_Register, IR_Output_Register;
    
    assign data_out = IR_Output_Register; 
    assign scan_out = IR_Scan_Register [0]; 
 
    always @(posedge clockIR) 
        IR_Scan_Register <= shiftIR ? {scan_in, IR_Scan_Register[IR_size-1:1]}:data_in; 
  
    always @(posedge updateIR or negedge reset_bar) // asynchronous required by 1140.1a.
        if(reset_bar==0) IR_Output_Register <= ~(0); // Fills IR with 1s for BYPASS instruction  
        else IR_Output_Register <= IR_Scan_Register;
endmodule 

module Boundary_Scan_Register #(parameter size=14) (
    output wire [size-1:0] data_out, output wire scan_out,
    input wire [size-1:0] data_in, input wire scan_in, shiftDR, mode, clockDR, updateDR); 
    
    reg [size-1:0] BSC_Scan_Register, BSC_Output_Register; 
 
    always @(posedge clockDR) 
        BSC_Scan_Register <= shiftDR ? {scan_in, BSC_Scan_Register[size-1:1]}:data_in; 

    always @(posedge updateDR) BSC_Output_Register <= BSC_Scan_Register; 
 
    assign scan_out = BSC_Scan_Register[0]; 
    assign data_out = mode ? BSC_Output_Register:data_in; 
endmodule 

module Bypass_Register(output reg scan_out, input wire scan_in, shiftDR, clockDR); 
  always @(posedge clockDR) scan_out <= scan_in & shiftDR;
endmodule 

