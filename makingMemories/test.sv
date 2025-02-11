module test(input [3:0] KEY, input [17:0] SW, output [17:0] LEDR, output [6:0] HEX0);
	wire [1:0] SEL;
	wire [2:0] OUT;
	handle(KEY, SEL); // Use handle to convert button input to select signal
	memory(SW[2:0], SEL, SW[17:17], OUT); // Run the memory module using select and enable to create a 3 bit output
	display(OUT, HEX0); // Use the 3 bit output and show it on the HEX display
endmodule

module display(input [2:0] D, output reg [6:0] HEX); // reads a 3 bit binary output and converts to a HEX display
	always @ (D) begin
		case (D)
			0: HEX <= 64;
			1: HEX <= 121;
			2: HEX <= 36;
			3: HEX <= 48;
			4: HEX <= 25;
			5: HEX <= 18;
			6: HEX <= 2;
			7: HEX <= 120;
		endcase
	end
endmodule

module handle(input [3:0] buttons, output reg [1:0] SEL); // Handles the button inputs and converts to a 2 bit select signal
	always @ (buttons) begin
		case (buttons)
			4'b0111: SEL <= 0;
			4'b1011: SEL <= 1;
			4'b1101: SEL <= 2;
			4'b1110: SEL <= 3;
			default: SEL <= SEL;
		endcase
	end
endmodule
