module test;	//test bench
localparam width = 32;
wire [7:0] o;	// output
reg [7:0] store [255:0];	// storage								
												
reg clk;             // clock
reg [width-1:0] x;  // input x
proc r1(o,x,clk);	// calling the module											
												

 initial 
     begin
		clk = 1;														
      end
      
always #5 clk = ~clk;													//Generating a clock of period 5

initial begin															//Inputs ; They get asssigned during rising edge of clock
	x = 32'b11000011110000110010001100100011;
	@(posedge clk)
#10
	x = 1234567890;
	@(posedge clk)
#10
	x = 32'b11000001111001010111001101100001;
	@(posedge clk)
#10
        x = 9618928321;
	@(posedge clk);
        @(posedge clk);
	$finish;
end
 

initial begin
	$dumpfile("Project.vcd");											//Generating a.vcd File
	$dumpvars;

end									
  
  
initial begin
	$monitor("Output:  %b	 Input: %b",o, x);						//Monitoring the Output
											
end



endmodule


