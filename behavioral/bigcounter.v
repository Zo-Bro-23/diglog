module bigcounter(input [1:0] SW, input [3:0] KEY, output [6:0] HEX0, HEX1, HEX2, HEX3);
	wire [15:0] Q;
	countermodule(SW[0], SW[1], ~KEY[0] ^ ~KEY[1] ^ ~KEY[2] ^ ~KEY[3], Q);
	bigdisplay(Q, HEX0, HEX1, HEX2, HEX3);
endmodule

module countermodule(input CLR, input EN, input CLK, output reg [15:0] Q);		
	always @ (posedge CLK) begin
		if (CLR) begin
			Q <= 16'b0000000000000000;
		end
		else if (EN) begin
			Q <= Q + 1;
		end
	end
endmodule

module bigdisplay(input [15:0] value, output [6:0] out1, out2, out3, out4);
	hexunit hex1(value[3:0], out1);
	hexunit hex2(value[7:4], out2);
	hexunit hex3(value[11:8], out3);
	hexunit hex4(value[15:12], out4);
endmodule
