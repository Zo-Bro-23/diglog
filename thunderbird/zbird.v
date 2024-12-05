module zbird(input [3:0] KEY, input [17:0] SW, output [17:0] LEDR);
	wire direction;
	assign direction = SW[0];
	
	light left(
		.clk(~KEY[2]), 
		.in(~direction & SW[17]),
		.reset(~KEY[3]), 
		.a(LEDR[11]), 
		.b(LEDR[10]), 
		.c(LEDR[9])
		);
	
	light right(
		.clk(~KEY[2]), 
		.in(direction & SW[17]), 
		.reset(~KEY[3]), 
		.a(LEDR[0]), 
		.b(LEDR[1]), 
		.c(LEDR[2]));
endmodule

module light(input clk, input reset, input in, output a, b, c);
	wire sn[1:0];
	wire s[1:0];
	DFFl flip0((s[0] & ~reset), clk, sn[0]);
	DFFl flip1((s[1] & ~reset), clk, sn[1]);
	assign s[0] = ~sn[0] & (in | sn[1]);
	assign s[1] = (sn[1] & ~sn[0]) | (~sn[1] & sn[0]);
	assign a = s[0] & s[1];
	assign b = s[1];
	assign c = s[0] | s[1];
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
