module part2(SW, LEDR);
	input [17:0] SW;
	output [17:0] LEDR;
	wire [3:0] one;
	wire [3:0] two;
	assign one[3:0]=SW[3:0];
	assign two[3:0]=SW[7:4];
	assign LEDR[9]=SW[9];
	assign LEDR[3:0]=(~{4{SW[9]}}&one)|({4{SW[9]}}&two);
endmodule
