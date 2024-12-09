module zbird(input [3:0] KEY, input [17:0] SW, output [17:0] LEDR);
	light mod(.clk(~KEY[2]), .reset(~KEY[3]), .in(SW[17]), .a(LEDR[0]), .b(LEDR[1]), .c(LEDR[2]));
endmodule

module light(input clk, input reset, input in, output reg a, b, c);
	always @(posedge clk) begin
		if(reset) begin
			a <= 0;
			b <= 0;
			c <= 0;
		end
		if(~a & ~b & ~c & in) begin
			a <= 1;
		end
		else begin
			if(a & b & c) begin
				a <= 0;
				b <= 0;
				c <= 0;
			end
			else begin
				b <= a;
				c <= b;
			end
		end
	end
endmodule
