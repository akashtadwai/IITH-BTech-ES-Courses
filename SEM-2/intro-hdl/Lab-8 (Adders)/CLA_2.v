module fa(output wire s, cout, input wire a, b, cin);
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule


module halfadder (output wire outs, output wire outc, input wire inx, input wire iny);
	
	assign outs = inx ^ iny;
	assign outc = inx & iny;

endmodule


module mux (output wire o1,input wire a1,b1,sel);
	assign o1 = (~sel&a1) | (sel&b1);
endmodule

module clab(output wire [15:0] z,output wire cout ,input wire [15:0] a,b,input wire cin);
	
	
	wire [3:0] c;
	wire [3:0] sl;
	wire [15:0] ps;
	wire [3:0] pc;
	
	assign c[0] = cin;
	wire r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12;
	fa f1(ps[0],t1,a[0],b[0],1'b0);
	fa f2(ps[1],t2,a[1],b[1],t1);
	fa f3(ps[2],t3,a[2],b[2],t2);
	fa f4(ps[3],pc[0],a[3],b[3],t3);
	
	fa f5(ps[4],t4,a[4],b[4],1'b0);
	fa f6(ps[5],t5,a[5],b[5],t4);
	fa f7(ps[6],t6,a[6],b[6],t5);
	fa f8(ps[7],pc[1],a[7],b[7],t6);
	
	fa f9(ps[8],t7,a[8],b[8],1'b0);
	fa f10(ps[9],t8,a[9],b[9],t7);
	fa f11(ps[10],t9,a[10],b[10],t8);
	fa f12(ps[11],pc[2],a[11],b[11],t9);
	
	fa f13(ps[12],t10,a[12],b[12],1'b0);
	fa f14(ps[13],t11,a[13],b[13],t10);
	fa f15(ps[14],t12,a[14],b[14],t11);
	fa f16(ps[15],pc[3],a[15],b[15],t12);
	
	and(sl[0],ps[0],ps[1],ps[2],ps[3]);
	and(sl[1],ps[4],ps[5],ps[6],ps[7]);
	and(sl[2],ps[8],ps[9],ps[10],ps[11]);
	and(sl[3],ps[12],ps[13],ps[14],ps[15]);
	
	mux m1(c[1],pc[0],1'b0,sl[0]);
	mux m2(c[2],pc[1],c[1],sl[1]);
	mux m3(c[3],pc[2],c[2],sl[2]);
	mux m4(cout,pc[3],c[3],sl[3]);
	
	halfadder h1(z[0],r1,ps[0],c[0]);
	halfadder h2(z[1],r2,ps[1],r1);
	halfadder h3(z[2],r3,ps[2],r2);
	halfadder h4(z[3],r4,ps[3],r3);
	
	halfadder h5(z[4],r5,ps[4],c[1]);
	halfadder h6(z[5],r6,ps[5],r5);
	halfadder h7(z[6],r7,ps[6],r6);
	halfadder h8(z[7],r8,ps[7],r7);
	
	halfadder h9(z[8],r9,ps[8],c[2]);
	halfadder h10(z[9],r10,ps[9],r9);
	halfadder h11(z[10],r11,ps[10],r10);
	halfadder h12(z[11],r12,ps[11],r11);
	
	halfadder h13(z[12],r13,ps[12],c[3]);
	halfadder h14(z[13],r14,ps[13],r13);
	halfadder h15(z[14],r15,ps[14],r14);
	halfadder h16(z[15],r16,ps[15],r15);
endmodule	
	
	
	
