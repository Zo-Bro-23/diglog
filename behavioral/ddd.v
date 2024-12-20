module ddd(input [3:0] KEY, output [2:0] LEDR);
	dddmain(~KEY[0], ~KEY[3], LEDR[0], LEDR[1], LEDR[2]);
endmodule

module dddmain(input clk, input d, output reg qa, output reg qb, output reg qc);
	always @ (clk) begin
		if (clk) begin
			qa <= d;
		end
	end
	
	always @ (posedge clk) begin
		qb <= d;
	end
	
	always @ (negedge clk) begin
		qc <= d;
	end
endmodule
