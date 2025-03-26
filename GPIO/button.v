module GPIO(input [1:0] SW, inout [29:0] GPIO);
	assign GPIO[27] = GPIO[8];
endmodule
