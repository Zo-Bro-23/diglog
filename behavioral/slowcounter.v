module slowcounter(input [1:0] SW, input CLOCK_50, input [0:0] KEY, output [6:0] HEX0, HEX1, HEX2, HEX3);
	wire [15:0] Q;
	slowmain(SW[0], CLOCK_50, Q);
	bigdisplay(Q, HEX0, HEX1, HEX2, HEX3);
endmodule

module slowmain(input CLR, input CLK, output [15:0] Q);
	wire [23:0] Q1;
	customcounter(CLR, 1'b1, CLK, Q1);
	countermodule(CLR, 1'b1, ~|Q1, Q);
endmodule

module customcounter(input CLR, input EN, input CLK, output reg [23:0] Q);		
	always @ (posedge CLK) begin
		if (CLR) begin
			Q <= 16'b000000000000000000000000;
		end
		else if (EN) begin
			Q <= Q + 1;
		end
	end
endmodule
