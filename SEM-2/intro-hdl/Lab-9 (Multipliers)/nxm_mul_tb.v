module test;
  localparam width1 = 4;
  localparam width2 = 3;
  reg [3:0] x,u;
  reg [2:0] y,v;
  wire [6:0] s;
  wire cout;
  reg clk,reset;

	initial begin 
        v = 3'b110; 
        u = 4'b0101;
        clk = 0;
        reset = 0;
    end
     
    initial begin
        $dumpfile("nXm_mul.vcd");
        $dumpvars;
    end
  
  nXm_mul nm (s,x,u,y,v,clk,reset);

	initial begin
		x = 4'b1110;y = 3'b010;
		#10;
		x = 4'b1010;y = 3'b100;
		#10;
		x = 4'b1100;y = 3'b111;
		#10;
		x = 4'b1011;y = 3'b101;
		$finish;
    end

	initial begin
        $monitor("At time %t,  %d	%d  %d  %d %d", $time,s,x,y,u,v);
	end
	
endmodule


