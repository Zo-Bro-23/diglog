module zbird(input [3:0] KEY, input [17:0] SW, output [17:0] LEDR);
	wire direction;
	assign direction = SW[0];
	
	// Right and left sides
	
	light left(
		.clk1(~KEY[2]),
		.clk2(~KEY[1]),
		.in(~direction & SW[17]),
		.reset(~KEY[3]), 
		.a(LEDR[11]), 
		.b(LEDR[10]), 
		.c(LEDR[9])
		);
	
	light right(
		.clk1(~KEY[2]),
		.clk2(~KEY[1]),
		.in(direction & SW[17]), 
		.reset(~KEY[3]), 
		.a(LEDR[0]), 
		.b(LEDR[1]), 
		.c(LEDR[2]));
endmodule

module light(input clk1, input clk2, input reset, input in, output a, b, c);
	// A single side

	wire CS[1:0];
	wire NS[1:0];
	DDFFl flip0((NS[0] & ~reset), clk1, clk2, CS[0]);
	DDFFl flip1((NS[1] & ~reset), clk1, clk2, CS[1]);
	assign NS[0] = ~CS[0] & (in | CS[1]);
	assign NS[1] = (CS[1] & ~CS[0]) | (~CS[1] & CS[0]);
	assign a = CS[0] & CS[1];
	assign b = CS[1];
	assign c = CS[0] | CS[1];
endmodule

module DDFFl(input d, input clk1, input clk2, output q);
	// Flip-flop with double clock signals to prevent bouncing

	wire t;
	DFFl flip0(d, clk1, t);
	DFFl flip1(t, clk2, q);
endmodule

module DFFl(input d, input clk, output q);
	wire CLK1;
	wire CLK2;
	wire Q1;
	wire Q2;
	assign CLK2 = clk;
	assign CLK1 = ~clk;
	DLat D1(d, CLK1, Q1);
	DLat D2(Q1, CLK2, Q2);
	assign q = Q2;
endmodule

module DLat(input d, input e, output q);
	assign q = ~((~d & e) | nq);
	assign nq = ~((d & e) | q);
endmodule
