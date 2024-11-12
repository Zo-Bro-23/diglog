module DLat(input d, input e, output q, output nq);
	assign q = ~((~d & e) | nq);
	assign nq = ~((d & e) | q);
endmodule
