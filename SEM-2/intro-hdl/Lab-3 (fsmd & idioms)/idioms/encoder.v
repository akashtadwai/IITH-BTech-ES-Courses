
module encode83_1 (output [2:0] o, input [7:0] a);
    reg [2:0] o;

    always @(a) begin
        casex (a)
            8'b00000001: o = 0;
            8'b00000010: o = 1;
            8'b00000100: o = 2;
            8'b00001000: o = 3;
            8'b00010000: o = 4;
            8'b00100000: o = 5;
            8'b01000000: o = 6;
            8'b10000000: o = 7;
            default: o = 3'bX;
        endcase
    end
endmodule


module encode83_2 (output [2:0] o, input [7:0] a);
    reg [2:0] o;
    
    reg [7:0] test;
    integer n;

    always @(a) begin
        test = 8'b00000001;
        o = 3'bX;
        for (n=0; n<8; n=n+1) begin
            if (a==test) o = n;
            test = test << 1;
        end
    end
endmodule

module test;
	wire [2:0]o;
	reg [7:0]a = 0;
	always #1 a = a << 1;
	encode83_2 e1(o,a);
	initial begin
	$monitor("%0d, %0d",o,a);
	#10 $finish;
	end
endmodule


module pri_encode83_1 (output [2:0] o, output valid, input [7:0] a);
    reg [2:0] o;
    reg valid;

    always @(a) begin
        valid = 1;
        casex (a)
            8'b1XXXXXXX: o = 7;
            8'b01XXXXXX: o = 6;
            8'b001XXXXX: o = 5;
            8'b0001XXXX: o = 4;
            8'b00001XXX: o = 3;
            8'b000001XX: o = 2;
            8'b0000001X: o = 1;
            8'b00000001: o = 0;
            default: begin
                valid = 0;
                o = 3'bX;
            end
        endcase
    end
endmodule


module decoder38_1 (output [7:0] o, input [2:0] a);
    reg [7:0] o;

    always @(a)
	begin
	casex(a)
	3'b000: o = 8'b00000001;
	3'b001: o = 8'b00000010;
endmodule

module decoder38_2 (output [7:0] o, input [2:0] a);
	
	reg[2:0] test;
	integer n;
	test = 3'b000;

	always @(a)
	begin
	for (n = 0; n < 8; n = n+1)
		begin
		if (a == test) o =n;
		test = test + 1;
		end
	end
endmodule
		 


