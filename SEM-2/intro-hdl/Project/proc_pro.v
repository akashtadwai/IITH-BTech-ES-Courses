


module proc(output wire [7:0] y, input wire [31:0] x,input wire clk);
reg sel;	
wire t,cin,s;							//Declaring all wires and registers
reg [7:0] a;
reg [7:0] b;
reg [7:0] z,z1;
reg [7:0] c1;
reg [7:0] i1;
reg [7:0] c;
reg [7:0] o;
wire [7:0] p;							
reg [7:0] storage [255:0];					//Memory Element for storage of the  Data

integer k;
assign s1 = x[31];
assign cin = 0;

Adder j1(t,p,a,b,cin);

always @(sel)							//Changes happening at change of selector
begin
    if (sel == 0)						//Operation regarding value of sel
	begin 
	   z = a & b;				//"AND" Operation of 2 bytes
	end
		
    else
	begin
	   z = p;					//Adding 2 bytes
	end
	
								
end

always @(posedge clk)						//Pipelining- pushing the values to registers after each of the clock cycles
begin
	sel <= s1;					
	a <= x[15:8];
	b <= x[7:0];
	z1 <= z;
	o<=z1;
	c1 <= x[23:16];
	k <= c1;						//Converting Binary output to an integer because here k is an integer and c1 is in binary
end
always@(*)
begin
	storage[k] = o;						//Storing the output in Memory
end

assign  y = storage[k];						//Assigning data in memory to output wire to display

endmodule

module Mux (output wire o,input wire a,b,sel);					//implementation of module mux
	assign o = (~sel&a) | (sel&b);
endmodule

module Xor (output wire o,input wire a,b); // XOR implementation
	assign o = (~b&a) | (~a&b);
endmodule

module Adder (output wire cout, output wire [7:0] s, input wire [7:0] x,y, input wire cin);    //This module adds 2 '8' bit numbers

wire sel[7:0];
wire c[8:0];
assign c[0] = cin;


	genvar i;
  generate
       for(i = 0; i < 8; i = i + 1)
	begin
			Xor s0(sel[i],x[i],y[i]);	
			Mux m0(c[i+1],y[i],c[i],sel[i]);    //Using mux to caluclate next carry states
			Xor z0(s[i],sel[i],c[i]);	    // Sum of two inputs  
	end
   endgenerate

assign cout = c[8];

endmodule
