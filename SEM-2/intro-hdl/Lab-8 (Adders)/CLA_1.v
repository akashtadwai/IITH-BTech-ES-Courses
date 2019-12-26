module CLA(sum,carry,x,y,cin);

		output  sum,carry;
		input  x,y,cin;
		wire t3,t4,t5,t6;
		xor(t3,x,y);
		xor(sum,t3,cin);//mux implementation
		not(t4,t3);
		and(t5,t4,y);
		and(t6,t3,cin);
		or(carry,t5,t6);//mux next carry state
endmodule
 module main(output wire [7:0]z,output wire cout,input wire [7:0] a,b,input wire cin);
			wire c[7:0];
			assign c[0] = cin;

			CLA v1(z[0],c[1],a[0],b[0],cin);
			CLA v2(z[1],c[2],a[1],b[1],c[1]);
			CLA v3(z[2],c[3],a[2],b[2],c[2]);
			CLA v4(z[3],c[4],a[3],b[3],c[3]);
			CLA v5(z[4],c[5],a[4],b[4],c[4]);
			CLA v6(z[5],c[6],a[5],b[5],c[5]);
			CLA v7(z[6],c[7],a[6],b[6],c[6]);
			CLA v8(z[7],cout,a[7],b[7],c[7]);
endmodule
