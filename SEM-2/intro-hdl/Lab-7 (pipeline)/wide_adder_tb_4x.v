module test;
 
  localparam width = 16;
  reg [width-1:0] A, B;
  reg clk,reset;
  reg C;

 
  initial 
	begin
		clk = 1;
		reset = 1'b0;
		C = 1'b0;
		#5 clk = ~clk;
	end
      
   initial 
	 begin
		{A, B} = {16'b0000000000000011, 16'b0000000000001000};
		#10;
		reset = 1'b1;
		reset = 1'b0;
		{A, B} = {16'b0000000000000011, 16'b0000000000000011};
		#10;
		reset = 1'b1;
		reset = 1'b0;
		{A, B} = {16'b0000000000000111, 16'b0000000000000001};
		#10;
		reset = 1'b1;
		reset = 1'b0;
		{A, B} = {16'b0000000000000101, 16'b0000000000001001};
		#10;
		reset = 1'b1;
		reset = 1'b0;
		{A, B} = {16'b0000000000001101, 16'b0000000000011101};
		#10;
		reset = 1'b1;
		reset = 1'b0;
		{A, B} = {16'b0000000000001101, 16'b0000000001011101};
	 end
   
   
  wire [width-1:0] A1;
  wire C1;
  adder_16bit wa (A1, C1, A, B, C, clk, reset);
  
  
  initial
    begin
        $monitor("At time %t, %0d     %0d     %0d     %0d     %0d", $time, A1, C1, A, B, C);
    end

endmodule
