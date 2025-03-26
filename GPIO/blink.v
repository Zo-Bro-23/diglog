module GPIO(input [1:0] SW, input CLOCK_50, inout [29:0] GPIO);
	wire [0:0] light;
	clock(CLOCK_50, light);
  assign GPIO[27] = clock;
endmodule

module clock(input clk, output reg pulse);
	reg [23:0] Q;
	always @ (posedge clk) begin
		Q <= Q + 1;
		if (&Q) pulse <= !pulse;
	end
endmodule
