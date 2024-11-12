module DFFl(input d, input clk, output Q, output NQ);
	wire CLK1;
	wire CLK2;
	wire Q1;
	wire NQ1;
	assign CLK2 = clk;
	assign CLK1 = ~clk;
	DLat D1(d, CLK1, Q1, NQ1);
	DLat D2(Q1, CLK2, Q, NQ);
endmodule
