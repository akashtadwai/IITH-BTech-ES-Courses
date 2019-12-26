module t_adder_with_TAP ();
    localparam size=4, BSC_Reg_size=14, IR_Reg_size=3, N_adder_Patterns=8,
        N_TAP_Instructions=8, Pause_Time=40, End_of_Test=1500, time_1=350, time_2=550; 
 
    wire [size-1:0] sum;
    wire c_out; 
    reg [size-1:0] a, b; 
    reg c_in; 
 
    reg TMS, TCK; 
    wire TDI, TDO; 
    reg load_TDI_Generator; 
    reg Error, strobe; 
    integer pattern_ptr; 
    reg [BSC_Reg_size-1:0] Array_of_adder_Test_Patterns[0:N_adder_Patterns-1]; 
    reg [IR_Reg_size-1:0] Array_of_TAP_Instructions[0:N_TAP_Instructions-1]; 
    reg [BSC_Reg_size-1: 0] Pattern_Register; // Size to maximum TDR 
    reg enable_bypass_pattern;
 
    adder_with_TAP M0 (.sum(sum), .c_out(c_out), .a(a), .b(b), .c_in(c_in), 
        .TDO(TDO), .TDI(TDI), .TMS(TMS), .TCK(TCK)); 
 
    wire [size-1:0] sum_fr_adder = M0.BSC_Interface[13:10]; 
    wire c_out_fr_adder = M0.BSC_Interface[9]; 
    wire [size-1:0] a_to_adder = M0.BSC_Interface[8:5]; 
    wire [size-1:0] b_to_adder = M0.BSC_Interface[4:1]; 
    wire c_in_to_adder = M0.BSC_Interface[0]; 

    TDI_Generator M1(.to_TDI(TDI), .scan_pattern(Pattern_Register), .load(load_TDI_Generator), 
        .enable_bypass_pattern(enable_bypass_pattern), .TCK(TCK)); 
  
    TDO_Monitor M3(.to_TDI(TDI), .from_TDO(TDO), .strobe(strobe), .TCK(TCK)); 
 
    initial #End_of_Test $finish;
 
    initial begin TCK = 0; forever #5 TCK = ~TCK; end	  
    /*  Summary of  a basic test plan for adder_with TAP 
    Verify default to bypass instruction 
    Verify bypass register action: Scan 10 cycles, with pause before exiting 
    Verify pull up action on TMS and TDI 
    Reset  to S_Reset after five assertions of TMS 
    Boundary scan in, pause, update, return to S_Run_Idle 
    Boundary scan in, pause, resume scan in, pause, update, return to S_Run_Idle 
    Instruction scan in, pause, update, return to S_Run_Idle 
    Instruction scan in, pause, resume scan in, pause, update, return to S_Run_Idle 
    */ 
    // TEST PATTERNS  
    // External I/O for normal operation 
 
    initial fork 
        {a, b, c_in} = 9'b1010_0101_0;  // sum = F, c_out = 0, a = A, b = 5, c_in = 0  
    join 
 
    initial begin
        $dumpfile("a.vcd");
        $dumpvars;
    end
    initial begin 		// Test sequence: Scan, pause, return to S_Run_Idle 
        strobe  = 0; 
        Declare_Array_of_TAP_Instructions; 
        Declare_Array_of_adder_Test_Patterns; 
        Wait_to_enter_S_Reset; 
 
    // Test for power-up and default to BYPASS instruction (all 1s in IR), with default path  
    // through the Bypass Register, with BSC register remaining in wakeup state (all x). 
    // adder test pattern is scanned serially, entering at TDI, passing through the bypass register, 
    // and exiting at TDO.  The BSC register and the IR are not changed. 
 
        pattern_ptr = 0; Load_adder_Test_Pattern; Go_to_S_Run_Idle; Go_to_S_Select_DR;
        Go_to_S_Capture_DR; Go_to_S_Shift_DR; enable_bypass_pattern = 1; Scan_Ten_Cycles;
        enable_bypass_pattern = 0; Go_to_S_Exit1_DR; Go_to_S_Pause_DR; Pause; Go_to_S_Exit2_DR;
        Go_to_S_Update_DR;
        Go_to_S_Run_Idle;
    end 
 
    // Test to load instruction register with INTEST instruction 
    initial #time_1 begin 
        pattern_ptr = 5;  
        strobe = 0; 
        Load_TAP_Instruction; Go_to_S_Run_Idle; Go_to_S_Select_DR; Go_to_S_Select_IR; 
        Go_to_S_Capture_IR;			// Capture dummy data (3'b101=idcode) 
        repeat (IR_Reg_size) Go_to_S_Shift_IR; 
        Go_to_S_Exit1_IR; Go_to_S_Pause_IR; Pause; 
        Go_to_S_Exit2_IR; Go_to_S_Update_IR; Go_to_S_Run_Idle; 
        
        //capture that data:
        Go_to_S_Select_DR; Go_to_S_Capture_DR; 
        strobe = 1; 
        repeat (BSC_Reg_size) Go_to_S_Shift_DR; 
        Go_to_S_Exit1_DR; Go_to_S_Pause_DR; Go_to_S_Exit2_DR; Go_to_S_Update_DR; 
        strobe = 0; Go_to_S_Run_Idle; 
    end 
   
 
    // Load adder test pattern  
    initial #time_2 begin 
        /*pattern_ptr = 0; Load_adder_Test_Pattern; Go_to_S_Run_Idle; Go_to_S_Select_DR; 
        Go_to_S_Capture_DR; 
        repeat (BSC_Reg_size) Go_to_S_Shift_DR; 
        Go_to_S_Exit1_DR; Go_to_S_Pause_DR; Pause; 
        Go_to_S_Exit2_DR; Go_to_S_Update_DR; Go_to_S_Run_Idle; 
 
        // Capture data and scan out while scanning in another pattern 
        pattern_ptr = 2; Load_adder_Test_Pattern; Go_to_S_Select_DR; Go_to_S_Capture_DR; 
        strobe = 1; 
        repeat (BSC_Reg_size) Go_to_S_Shift_DR; 
        Go_to_S_Exit1_DR; Go_to_S_Pause_DR; Go_to_S_Exit2_DR; Go_to_S_Update_DR; 
        strobe = 0; Go_to_S_Run_Idle; */
    end 
 
    /************************************** TAP CONTROLLER TASKS *************************************/ 
    task Wait_to_enter_S_Reset; @(negedge TCK) TMS = 1; endtask 
    task Reset_TAP; begin TMS = 1; repeat (5) @ (negedge TCK); end endtask
    task Pause; begin #Pause_Time; end endtask 
    task Go_to_S_Reset; begin @(negedge TCK) TMS = 1; end endtask 
    task Go_to_S_Run_Idle; begin @ (negedge TCK) TMS = 0; end endtask 
 
    task Go_to_S_Select_DR; begin @ (negedge TCK) TMS = 1; end endtask 
    task Go_to_S_Capture_DR; begin @ (negedge TCK) TMS = 0; end endtask 
    task Go_to_S_Shift_DR; begin @ (negedge TCK) TMS = 0; end endtask 
    task Go_to_S_Exit1_DR; begin @ (negedge TCK) TMS = 1; end endtask 
    task Go_to_S_Pause_DR; begin @ (negedge TCK) TMS = 0; end endtask 
    task Go_to_S_Exit2_DR; begin @ (negedge TCK) TMS = 1; end endtask 
    task Go_to_S_Update_DR; begin @ (negedge TCK) TMS = 1; end endtask 
    task Go_to_S_Select_IR; begin @ (negedge TCK) TMS = 1; end endtask 
    task Go_to_S_Capture_IR; begin @ (negedge TCK) TMS = 0; end endtask 
    task Go_to_S_Shift_IR; begin @ (negedge TCK) TMS = 0; end endtask 
    task Go_to_S_Exit1_IR; begin @ (negedge TCK) TMS = 1; end endtask 
    task Go_to_S_Pause_IR; begin @ (negedge TCK) TMS = 0; end endtask 
    task Go_to_S_Exit2_IR; begin @ (negedge TCK) TMS = 1; end endtask 
    task Go_to_S_Update_IR; begin @ (negedge TCK) TMS = 1; end endtask 
    task Scan_Ten_Cycles; begin repeat (10) begin @ (negedge TCK) TMS = 0; @ (posedge TCK) TMS = 1; end end endtask 
 
    /************************************** adder TEST PATTERNS  *************************************/ 
    task Load_adder_Test_Pattern; begin 
        Pattern_Register = Array_of_adder_Test_Patterns[pattern_ptr]; 
        @ (negedge TCK ) load_TDI_Generator = 1; 
        @ (negedge TCK) load_TDI_Generator = 0; 
    end 
    endtask 
 
    task Declare_Array_of_adder_Test_Patterns; begin 
        //s3 s2 s1 s0_ c0_a3 a2 a1 a0_b3 b2 b1 b0_c_in; 
        Array_of_adder_Test_Patterns [0] = 14'b0100_1_1010_1010_0;  
        Array_of_adder_Test_Patterns [1] = 14'b0000_0_0000_0000_0;  
        Array_of_adder_Test_Patterns [2] = 14'b1111_1_1111_1111_1;   
        Array_of_adder_Test_Patterns [3] = 14'b0100_1_0101_0101_0; 
    end endtask 
 
    /************************************** INSTRUCTION PATTERNS *************************************/ 
    localparam BYPASS = 3'b111, EXTEST = 3'b000, SAMPLE_PRELOAD = 3'b010, INTEST = 3'b011,
        RUNBIST = 3'b100, IDCODE = 3'b101; 
 
    task Load_TAP_Instruction; begin 
        Pattern_Register = Array_of_TAP_Instructions [pattern_ptr]; 
        @ (negedge TCK ) load_TDI_Generator = 1; 
        @ (negedge TCK) load_TDI_Generator = 0; 
    end 
    endtask 
 
    task Declare_Array_of_TAP_Instructions; begin 
        Array_of_TAP_Instructions [0] = BYPASS; 
        Array_of_TAP_Instructions [1] = EXTEST; 
        Array_of_TAP_Instructions [2] = SAMPLE_PRELOAD; 
        Array_of_TAP_Instructions [3] = INTEST; 
        Array_of_TAP_Instructions [4] = RUNBIST; 
        Array_of_TAP_Instructions [5] = IDCODE; 
    end 
    endtask   
endmodule 
 
module TDI_Generator #(parameter BSC_Reg_size=14) (
    output wire to_TDI, input wire [BSC_Reg_size-1:0] scan_pattern, input wire load, enable_bypass_pattern, TCK);

    reg [BSC_Reg_size-1:0] TDI_Reg; 
    wire enableTDO = t_adder_with_TAP.M0.enableTDO; 
    assign to_TDI = TDI_Reg[0]; 

    always @(posedge TCK) 
        if (load) TDI_Reg <= scan_pattern;
        else if (enableTDO || enable_bypass_pattern) TDI_Reg <= TDI_Reg >> 1; 
endmodule 

module TDO_Monitor #(parameter BSC_Reg_size=14) (
    output wire to_TDI, input wire from_TDO, strobe, TCK); 

    reg [BSC_Reg_size-1:0] TDI_Reg, Pattern_Buffer_1, Pattern_Buffer_2, Captured_Pattern, TDO_Reg; 
    reg Error; 
    wire enableTDO = t_adder_with_TAP.M0.enableTDO; 
    localparam test_width = 5; 
    wire [test_width-1:0] Expected_out = Pattern_Buffer_2[BSC_Reg_size-1:BSC_Reg_size-test_width]; 
    wire [test_width-1:0] adder_out = TDO_Reg[BSC_Reg_size-1:BSC_Reg_size-test_width]; 
 
    initial Error = 0;

    always @ (negedge enableTDO) if (strobe == 1) Error = |(Expected_out^adder_out); 
    
    always @ (posedge TCK) 
        if (enableTDO) begin 
            Pattern_Buffer_1 <= {to_TDI, Pattern_Buffer_1[BSC_Reg_size-1:1]}; 
            Pattern_Buffer_2 <= {Pattern_Buffer_1[0], Pattern_Buffer_2[BSC_Reg_size-1:1]}; 
            TDO_Reg <= {from_TDO, TDO_Reg[BSC_Reg_size-1:1]}; 
        end   
endmodule 
