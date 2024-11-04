module part2(input[17:0] SW, output[17:0] LEDR);
	assign LEDR[9]=SW[9];
	assign LEDR[3:0]=SW[9]?SW[7:4]:SW[3:0];
endmodule
