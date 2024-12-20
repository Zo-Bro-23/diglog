module slowcounter(input [1:0] SW, input CLOCK_50, input [0:0] KEY, output [6:0] HEX0, HEX1, HEX2, HEX3);
	wire [15:0] Q;
	slowmain(SW[0], CLOCK_50, Q);
	bigdisplay(Q, HEX0, HEX1, HEX2, HEX3);
endmodule

module slowmain(input CLR, input CLK, output [15:0] Q);
	wire [15:0] Q1;
	wire [3:0] Q2;
	countermodule(CLR, 1'b1, CLK, Q1);
	smallcounter(~|Q1, CLK, CLR, Q2);
	countermodule(CLR, ~|Q1, CLK, Q);
	//countermodule(CLR, ~|Q2, CLK, Q);
	//countermodule(CLR, ~|Q3, CLK, Q);
endmodule
