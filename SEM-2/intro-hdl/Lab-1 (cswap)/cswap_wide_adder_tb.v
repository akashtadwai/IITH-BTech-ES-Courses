`timescale 1 ns / 100 ps

module test;
  localparam width = 4;
  reg [width-1:0] A, B;
  reg C;

  initial
  begin
      A = 0;
      B = 0;
      C = 0;
  end
  always #1 A = A+1;
  always #2 B = B+1;
  always #4 C = !C;

  wire [width-1:0] A1;
  wire C1;
  //cswap c1 (A1, B1, C1, A, B, C);
  //cswap c1 (A1.(A1), .B1(B1), .C1(C1), .A(A), .B(B), .C(C));
  //cswap_fa fa1(A1, B1, A, B, C);
  cswap_wide_adder #(.width(width)) wa (A1, C1, A, B, C);
  initial
    begin
        $monitor("At time %t, %0d %0d %0d %0d %0d", $time, A1, C1, A, B, C);
        #100 $finish;
    end
  initial
    begin
        $dumpfile("wide_adder.vcd"); 
        $dumpvars;
    end 
endmodule // test


