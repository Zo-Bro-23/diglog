module adventure(input [1:0] SW, input [3:0] KEY, input CLOCK_50, output LCD_ON, output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2, output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5, output [6:0] HEX6, output [17:0] LEDR);
	main(KEY, CLOCK_50, LCD_ON, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, LEDR);
endmodule

module main(input [3:0] buttons, input clock, output LCD, output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2, output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5, output [6:0] HEX6, output [17:0] LED);
	wire [1:0] outcome;
	wire sword;
	wire clk;
	reg [2:0] direction;
	reg reset;
	
	always @ (buttons) begin
		reset = 0;
		case (buttons)
			4'b1110: direction <= 1;
			4'b1101: direction <= 2;
			4'b1011: direction <= 0;
			4'b0111: direction <= 3;
			4'b0000: reset <= 1;
			default: direction <= 7;
		endcase
	end
	
	clock(clock, clk);
	assign LCD = clk;
	room(direction, sword, clk, reset, outcome, HEX5, HEX4, HEX6, HEX3, HEX2, HEX1, HEX0, LED);
	sword(outcome, clk, reset, sword);
endmodule

module clock(input clk, output reg pulse);
	reg [23:0] Q;
	always @ (posedge clk) begin
		Q <= Q + 1;
		if (&Q) pulse <= !pulse;
	end
endmodule

module sword(input [1:0] outcome, input clk, input reset, output reg sword);
	parameter SWORD = 0, RUNNING = 1, WIN = 2, DIE = 3;
	parameter NO = 0, YES = 1;
	reg state;
	reg nextstate;
	
	always @ (state) begin
		sword <= state;
	end
	
	always @ (state or outcome) begin
		case (state)
			NO:
				case (outcome)
					SWORD:
						nextstate <= YES;
					default: nextstate <= NO;
				endcase
			YES:
				nextstate <= YES;
		endcase
	end
	
	always @ (posedge clk) begin
		if (reset) state <= NO;
		else state <= nextstate;
	end
endmodule

module room(input [2:0] direction, input sword, input clk, input reset, output reg [1:0] outcome, output reg [6:0] IND, output reg [6:0] IND2, output reg [6:0] dIND, output reg [6:0] DISP1, output reg [6:0] DISP2, output reg [6:0] DISP3, output reg [6:0] DISP4, output reg [17:0] LED, output reg [3:0] state);
	parameter CC = 0, TT = 1, RR = 2, SSS = 3, DD = 4, GG = 5, VV = 6;
	parameter SWORD = 0, RUNNING = 1, WIN = 2, DIE = 3;
	parameter N = 2'b00, E = 2'b01, S = 2'b10, W = 2'b11, NIL = 7;
	reg [3:0] nextstate;
	
	always @ (state) begin
		case (state)
			CC: outcome <= RUNNING;
			TT: outcome <= RUNNING;
			RR: outcome <= RUNNING;
			SSS: outcome <= SWORD;
			DD: outcome <= RUNNING;
			GG: outcome <= DIE;
			VV: outcome <= WIN;
		endcase
		case (state)
			CC: LED <= 1;
			TT: LED <= 1;
			RR: LED <= 1;
			SSS: LED <= 8;
			DD: LED <= 1;
			GG: LED <= 2;
			VV: LED <= 4;
			default: LED <= 0;
		endcase
		case (state)
			CC: DISP1 <= 47;
			TT: DISP1 <= 47;
			RR: DISP1 <= 47;
			SSS: DISP1 <= 18;
			DD: DISP1 <= 47;
			GG: DISP1 <= 33;
			VV: DISP1 <= 71;
		endcase
		case (state)
			CC: DISP2 <= 99;
			TT: DISP2 <= 99;
			RR: DISP2 <= 99;
			SSS: DISP2 <= 99;
			DD: DISP2 <= 99;
			GG: DISP2 <= 121;
			VV: DISP2 <= 121;
		endcase
		case (state)
			CC: DISP3 <= 43;
			TT: DISP3 <= 43;
			RR: DISP3 <= 43;
			SSS: DISP3 <= 47;
			DD: DISP3 <= 43;
			GG: DISP3 <= 6;
			VV: DISP3 <= 99;
		endcase
		case (state)
			CC: DISP4 <= 127;
			TT: DISP4 <= 127;
			RR: DISP4 <= 127;
			SSS: DISP4 <= 33;
			DD: DISP4 <= 127;
			GG: DISP4 <= 127;
			VV: DISP4 <= 6;
		endcase
		case (state)
			CC: IND <= 70;
			TT: IND <= 7;
			RR: IND <= 47;
			SSS: IND <= 18;
			DD: IND <= 33;
			GG: IND <= 16;
			VV: IND <= 99;
		endcase
		case (state)
			CC: IND2 <= 70;
			TT: IND2 <= 7;
			RR: IND2 <= 47;
			SSS: IND2 <= 18;
			DD: IND2 <= 33;
			GG: IND2 <= 16;
			VV: IND2 <= 99;
		endcase
		case (state)
			CC: dIND <= 7'b1111001;
			TT: dIND <= 7'b1000111;
			RR: dIND <= 7'b1001000;
			SSS: dIND <= 7'b1111001;
			DD: dIND <= 7'b0111111;
			GG: dIND <= 7'b0111111;
			VV: dIND <= 7'b0111111;
		endcase
	end
	
	always @ (state or direction) begin
		case (state)
			CC:
				case (direction)
					E: nextstate <= TT;
					default: nextstate <= CC;
				endcase
			TT:
				case (direction)
					W: nextstate <= CC;
					S: nextstate <= RR;
					default: nextstate <= TT;
				endcase
			RR:
				case (direction)
					W: nextstate <= SSS;
					N: nextstate <= TT;
					E: nextstate <= DD;
					default: nextstate <= RR;
				endcase
			SSS:
				case (direction)
					E: nextstate <= RR;
					default: nextstate <= SSS;
				endcase
			DD:
				if (sword) nextstate <= VV;
				else nextstate <= GG;
			GG:
				nextstate <= GG;
			VV:
				nextstate <= VV;
		endcase
	end
	
	always @ (posedge clk) begin
		if (reset) state <= CC;
		else state <= nextstate;
		//state <= nextstate;
	end
endmodule
