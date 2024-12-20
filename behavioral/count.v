module count(input [17:0] SW, input [3:0] KEY, output [17:0] LEDR);
	smallcounter(SW[1], ~KEY[0], SW[0], LEDR[3:0]);
endmodule

module smallcounter(input EN, input CLK, input CLR, output [3:0] Q);
	t c1(EN, CLK, CLR, Q[0]);
	t c2(EN & Q[0], CLK, CLR, Q[1]);
	t c3(EN & Q[0] & Q[1], CLK, CLR, Q[2]);
	t c4(EN & Q[0] & Q[1] & Q[2], CLK, CLR, Q[3]);
endmodule

module t(input T, input CLK, input CLR, output reg Q, output reg NQ);
	always @ (posedge CLK) begin
		if (T) begin
			Q <= NQ;
			NQ <= Q;
		end
		if (CLR) begin
			Q <= 1'b0;
			NQ <= 1'b1;
		end
	end
endmodule
