module clab_test;

  localparam width = 16;
  reg [width-1:0] a, b;
  reg cin;
  reg clk,reset;

  wire [width-1:0] z;
  wire cout;
  clab v1(z,cout,a,b,cin);


  initial begin
		clk = 0;
		cin = 1'b0;
		reset <= 0 ;
   end
   always #10 clk = ~clk;

   initial begin


		 a = 16'hA ;b = 16'hB;

		 #20 a = 12; b = 2;

		 #20 a = 9;b = 16;

		 #20 a = 2;b = 8;
		 #100  $finish;

	 end



  initial begin
	$dumpfile ("cla2.vcd");
	$dumpvars;
        $monitor(" At time %t,%0d   %0d     %0d  %0d   %0d    ", $time, z,cout,a,b,cin);

    end

endmodule
