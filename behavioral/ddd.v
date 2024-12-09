module ddd(input clk, input d, output reg qa, output reg qb, output reg qc);
	always @ (clk) begin
		if(clk) begin
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
