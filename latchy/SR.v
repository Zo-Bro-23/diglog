module SR(input s, input r, output q, output nq);
	assign q = ~(r | nq);
	assign nq = ~(s | q);
endmodule
