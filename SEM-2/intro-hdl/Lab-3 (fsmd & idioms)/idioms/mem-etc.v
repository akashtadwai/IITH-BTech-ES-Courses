module memtest;

    reg [7:0] mem[0:31];
    wire [7:0] a;
    reg [7:0] b;
    integer file, i, j, n = 20;

    initial begin
        $readmemb ("mem.txt", mem, 5);
        for(i=20; i<100; i=i+1)
            mem[i] = 32'hdead_beef;
    end
    assign a = mem[3];

    initial begin
        b = $random;
        file = $fopen("file.txt");
	for (j = 0; j < n; j = j +1)
	begin
        $fwrite(file, "%d\n", j);
	end
        $fclose(file);
    end
endmodule
