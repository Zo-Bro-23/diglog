module rotate(input [1:0] SW, input CLOCK_50, output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	rotatemain(SW[0], CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
endmodule

module rotatemain(input CLR, input CLK, output [6:0] out0, out1, out2, out3, out4, out5, out6, out7);
	wire [2:0] SEL;
	selectorcounter(CLR, CLK, SEL);
	de10(SEL, out0, out1, out2, out3, out4, out5, out6, out7);
endmodule

module selectorcounter(input CLR, input CLK, output reg [2:0] SEL);
	wire [23:0] Q;
	customcounter(CLR, 1'b1, CLK, Q);
	always @ (posedge ~|Q) begin
		if (CLR) begin
			SEL <= 3'b000;
		end
		else begin
			SEL <= SEL + 1;
		end
	end
endmodule

module de10(input [2:0] SEL, output reg [6:0] out0, out1, out2, out3, out4, out5, out6, out7);
	always @ (SEL) begin
		case (SEL)
			3'b001: out7 <= 7'b1000000;
			3'b010: out7 <= 7'b1111001;
			3'b011: out7 <= 7'b0000110;
			3'b100: out7 <= 7'b0100001;
			
			3'b000: out7 <= 7'b1111111;
			3'b101: out7 <= 7'b1111111;
			3'b110: out7 <= 7'b1111111;
			3'b111: out7 <= 7'b1111111;
		endcase
		case (SEL)
			3'b010: out6 <= 7'b1000000;
			3'b011: out6 <= 7'b1111001;
			3'b100: out6 <= 7'b0000110;
			3'b101: out6 <= 7'b0100001;
			
			3'b000: out6 <= 7'b1111111;
			3'b001: out6 <= 7'b1111111;
			3'b110: out6 <= 7'b1111111;
			3'b111: out6 <= 7'b1111111;
		endcase
		case (SEL)
			3'b011: out5 <= 7'b1000000;
			3'b100: out5 <= 7'b1111001;
			3'b101: out5 <= 7'b0000110;
			3'b110: out5 <= 7'b0100001;
			
			3'b000: out5 <= 7'b1111111;
			3'b001: out5 <= 7'b1111111;
			3'b010: out5 <= 7'b1111111;
			3'b111: out5 <= 7'b1111111;
		endcase
		case (SEL)
			3'b100: out4 <= 7'b1000000;
			3'b101: out4 <= 7'b1111001;
			3'b110: out4 <= 7'b0000110;
			3'b111: out4 <= 7'b0100001;
			
			3'b000: out4 <= 7'b1111111;
			3'b001: out4 <= 7'b1111111;
			3'b010: out4 <= 7'b1111111;
			3'b011: out4 <= 7'b1111111;
		endcase
		case (SEL)
			3'b000: out3 <= 7'b0100001;
			3'b111: out3 <= 7'b0000110;
			3'b110: out3 <= 7'b1111001;			
			3'b101: out3 <= 7'b1000000;
			
			3'b001: out3 <= 7'b1111111;
			3'b010: out3 <= 7'b1111111;
			3'b011: out3 <= 7'b1111111;
			3'b100: out3 <= 7'b1111111;
		endcase
		case (SEL)
			3'b000: out2 <= 7'b0000110;
			3'b111: out2 <= 7'b1111001;
			3'b110: out2 <= 7'b1000000;
			3'b001: out2 <= 7'b0100001;
			
			3'b010: out2 <= 7'b1111111;
			3'b011: out2 <= 7'b1111111;
			3'b100: out2 <= 7'b1111111;
			3'b101: out2 <= 7'b1111111;
		endcase
		case (SEL)
			3'b000: out1 <= 7'b1111001;
			3'b111: out1 <= 7'b1000000;
			3'b010: out1 <= 7'b0100001;
			3'b001: out1 <= 7'b0000110;
			
			3'b011: out1 <= 7'b1111111;
			3'b100: out1 <= 7'b1111111;
			3'b101: out1 <= 7'b1111111;
			3'b110: out1 <= 7'b1111111;
		endcase
		case (SEL)
			3'b000: out0 <= 7'b1000000;
			3'b011: out0 <= 7'b0100001;
			3'b010: out0 <= 7'b0000110;
			3'b001: out0 <= 7'b1111001;
			
			3'b100: out0 <= 7'b1111111;
			3'b101: out0 <= 7'b1111111;
			3'b110: out0 <= 7'b1111111;
			3'b111: out0 <= 7'b1111111;
		endcase
	end
endmodule
