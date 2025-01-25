module waveform(input [3:0] buttons, input clock, output LCD, output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2, output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5, output [6:0] HEX6, output [17:0] LED, output [3:0] state);
	wire [1:0] outcome;
	wire sword;
	wire clk;
	reg [2:0] direction;
	reg reset;
	
	always @ (buttons) begin
		reset = 0;
		case (buttons)
			4'b0001: direction <= 1;
			4'b0010: direction <= 2;
			4'b0100: direction <= 0;
			4'b1000: direction <= 3;
			4'b1111: reset <= 1;
			default: direction <= 7;
		endcase
	end
	
	room(direction, sword, clock, reset, outcome, HEX5, HEX4, HEX6, HEX3, HEX2, HEX1, HEX0, LED, state);
	sword(outcome, clock, reset, sword);
endmodule
