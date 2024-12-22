module zohan(input [1:0] SW, input CLOCK_50, output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	zohanmain(SW[0], CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
endmodule

module zohanmain(input CLR, input CLK, output [6:0] out0, out1, out2, out3, out4, out5, out6, out7);
	wire [2:0] SEL;
	selectorcounter(CLR, CLK, SEL);
	zo(SEL, out0, out1, out2, out3, out4, out5, out6, out7);
endmodule

module zo(input [2:0] SEL, output reg [6:0] out0, out1, out2, out3, out4, out5, out6, out7);
	always @ (SEL) begin
		case (SEL)
			3'b000: out7 <= 7'b1111111;
			3'b001: out7 <= 7'b0101011;
			3'b010: out7 <= 7'b0001000;
			3'b011: out7 <= 7'b0001011;
			
			3'b100: out7 <= 7'b0100011;			
			3'b101: out7 <= 7'b0100100;
			3'b110: out7 <= 7'b1111111;
			3'b111: out7 <= 7'b1111111;
		endcase
		case (SEL)
			3'b000: out6 <= 7'b1111111;
			3'b001: out6 <= 7'b1111111;
			3'b010: out6 <= 7'b0101011;
			3'b011: out6 <= 7'b0001000;
			
			3'b100: out6 <= 7'b0001011;
			3'b101: out6 <= 7'b0100011;
			3'b110: out6 <= 7'b0100100;
			3'b111: out6 <= 7'b1111111;
		endcase
		case (SEL)
			3'b000: out5 <= 7'b1111111;
			3'b001: out5 <= 7'b1111111;
			3'b010: out5 <= 7'b1111111;
			3'b011: out5 <= 7'b0101011;
			
			3'b100: out5 <= 7'b0001000;
			3'b101: out5 <= 7'b0001011;
			3'b110: out5 <= 7'b0100011;			
			3'b111: out5 <= 7'b0100100;
		endcase
		case (SEL)
			3'b000: out4 <= 7'b0100100;
			3'b001: out4 <= 7'b1111111;
			3'b010: out4 <= 7'b1111111;
			3'b011: out4 <= 7'b1111111;
		
			3'b100: out4 <= 7'b0101011;
			3'b101: out4 <= 7'b0001000;
			3'b110: out4 <= 7'b0001011;
			3'b111: out4 <= 7'b0100011;
		endcase
		case (SEL)
			3'b000: out3 <= 7'b0100011;
			3'b001: out3 <= 7'b0100100;
			3'b010: out3 <= 7'b1111111;
			3'b011: out3 <= 7'b1111111;
			
			3'b100: out3 <= 7'b1111111;
			3'b101: out3 <= 7'b0101011;
			3'b110: out3 <= 7'b0001000;
			3'b111: out3 <= 7'b0001011;
		endcase
		case (SEL)
			3'b000: out2 <= 7'b0001011;
			3'b001: out2 <= 7'b0100011;
			3'b010: out2 <= 7'b0100100;
			3'b011: out2 <= 7'b1111111;
			
			3'b100: out2 <= 7'b1111111;
			3'b101: out2 <= 7'b1111111;
			3'b110: out2 <= 7'b0101011;
			3'b111: out2 <= 7'b0001000;
		endcase
		case (SEL)
			3'b000: out1 <= 7'b0001000;
			3'b001: out1 <= 7'b0001011;
			3'b010: out1 <= 7'b0100011;
			3'b011: out1 <= 7'b0100100;
			
			3'b100: out1 <= 7'b1111111;
			3'b101: out1 <= 7'b1111111;
			3'b110: out1 <= 7'b1111111;
			3'b111: out1 <= 7'b0101011;
		endcase
		case (SEL)
			3'b000: out0 <= 7'b0101011;
			3'b001: out0 <= 7'b0001000;
			3'b010: out0 <= 7'b0001011;
			3'b011: out0 <= 7'b0100011;
			
			3'b100: out0 <= 7'b0100100;
			3'b101: out0 <= 7'b1111111;
			3'b110: out0 <= 7'b1111111;
			3'b111: out0 <= 7'b1111111;
		endcase
	end
endmodule
