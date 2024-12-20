module add(input [17:0] SW, input[3:0] KEY, output [6:0] HEX0, HEX1, HEX2);
		addmain(SW[7:0], SW[8:8], SW[9:9], SW[11:10], ~KEY[0], HEX0, HEX1, HEX2);
endmodule

module addmain(input [7:0] IN, input SEL, input EN, input [1:0] DIS, input CLK, output [6:0] HEX0, HEX1, HEX2);
	reg [7:0] A, B;
	reg [8:0] out;
	
	hexdisplay(out, HEX0, HEX1, HEX2);
	
	always @ (posedge CLK) begin
		if (EN) begin
			if (SEL) begin
				B = IN;
			end
			else begin
				A = IN;
			end
		end
		case (DIS)
			2'b00: out <= A;
			2'b01: out <= B;
			2'b10: out <= A+B;
			2'b11: out <= 8'b00000000;
		endcase
	end
endmodule

module hexdisplay(input [11:0] value, output [6:0] out1, out2, out3);
	hexunit hex1(value[3:0], out1);
	hexunit hex2(value[7:4], out2);
	hexunit hex3(value[11:8], out3);
endmodule

module hexunit(input [3:0] value, output reg [6:0] out);
	always @ (value) begin
		case (value)
			4'b0000: out <= 7'b1000000;
			4'b0001: out <= 7'b1111001;
			4'b0010: out <= 7'b0100100;
			4'b0011: out <= 7'b0110000;
			4'b0100: out <= 7'b0011001;
			4'b0100: out <= 7'b0001001;
			4'b0101: out <= 7'b0010010;
			4'b0110: out <= 7'b0000010;
			4'b0111: out <= 7'b1111000;
			4'b1000: out <= 7'b0000000;
			4'b1001: out <= 7'b0011000;
			4'b1010: out <= 7'b0001000;
			4'b1011: out <= 7'b0000011;
			4'b1100: out <= 7'b1000110;
			4'b1101: out <= 7'b0100001;
			4'b1110: out <= 7'b0000110;
			4'b1111: out <= 7'b0001110;
		endcase
	end
endmodule
