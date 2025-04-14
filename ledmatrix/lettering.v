module lettering(output [15:0] GPIO, input CLOCK_50, output [17:0] LEDR);
	letterbody(CLOCK_50, GPIO[2:0], GPIO[6:4], GPIO[11:8], GPIO[12], GPIO[13], GPIO[14], GPIO[3], GPIO[15], GPIO[7]);
endmodule

module letterbody(input CLOCK, output reg [2:0] RGB1, output reg [2:0] RGB2, output reg [3:0] addr, output reg CLK, LAT, OE, output GND1, GND2, GND3);
	assign GND1 = 0;
	assign GND2 = 0;
	assign GND3 = 0;
	
	reg clk;
	
	reg [24:0] clkcounter = 0;
	reg [24:0] rowcounter = 8025; // Starting high to allow it time to setup before starting the first line
	reg [24:0] addrcounter = 0;
	reg [24:0] animcounter = 0;
	reg [24:0] lettercounter = 0;
	
	reg [111:0] store1 = 112'b0000111110011001100110011001111101101111011011110110100110010001100111001111100101101111111101111111011101100000;
	reg [111:0] store2 = 112'b0000010001100110100110011001011000111001100111111001101111110001011110000110111100010111001110010001110110010000;
	reg [111:0] store3 = 112'b0011001001100110111110011001011011000111110100111001110110010001011110010110111111010001001110010001110111110000;
	reg [111:0] store4 = 112'b0011111101101001100101101111011000111001111000110110100110011111100101111111100111110001111101111111011110010000;
	
	reg [63:0] row1 = 0;
	reg [63:0] row2 = 0;
	reg [63:0] row3 = 0;
	reg [63:0] row4 = 0;
	
	reg [215:0] message = 216'h00001B04050B0F0F03000D010009001B040C120F17000F0C0C0508;
	
	always @ (posedge CLOCK) begin
		clkcounter = clkcounter + 1;
		if (clkcounter == 1) begin
			clkcounter = 0;
			clk = !clk;
			if (rowcounter <= 63) CLK = clk;
			else CLK = 0;
		end
	end
	
	always @ (posedge clk) begin // Don't know why posedge works and negedge doesn't
		if (rowcounter <= 63) begin
			if (addrcounter == 2) begin
				RGB1 <= {3{row1[rowcounter]}};
			end
			else if (addrcounter == 3) begin
				RGB1 <= {3{row2[rowcounter]}};
			end
			else if (addrcounter == 4) begin
				RGB1 <= {3{row3[rowcounter]}};
			end
			else if (addrcounter == 5) begin
				RGB1 <= {3{row4[rowcounter]}};
			end
			else begin
				RGB1 <= 3'b000;
			end
			RGB2 <= 3'b000;
		end
		if (rowcounter == 500) OE <= 0; // Don't know why active high works and not active low
		if (rowcounter == 550) LAT <= 1;
		if (rowcounter == 600) LAT <= 0;
		if (rowcounter == 650) OE <= 1;
		rowcounter <= rowcounter + 1;
		if (rowcounter == 8000) begin
			addr <= addr + 1; // Confusing because of non blocking assignment
			addrcounter[3:0] <= addr + 2; // WHY? WHY??? Why does Matrix update address befofre
		end
		if (rowcounter == 8050) rowcounter <= 0; // Generally good to allow space?
		
		animcounter <= animcounter + 1;
		if (animcounter == 8000000) begin
			row1[55:0] <= row1[63:8];
			row1[63:56] <= {2'b00, store1[(message[(lettercounter * 8) +: 8] * 4) +: 4], 2'b00};
			row2[55:0] <= row2[63:8];
			row2[63:56] <= {2'b00, store2[(message[(lettercounter * 8) +: 8] * 4) +: 4], 2'b00};
			row3[55:0] <= row3[63:8];
			row3[63:56] <= {2'b00, store3[(message[(lettercounter * 8) +: 8] * 4) +: 4], 2'b00};
			row4[55:0] <= row4[63:8];
			row4[63:56] <= {2'b00, store4[(message[(lettercounter * 8) +: 8] * 4) +: 4], 2'b00};
			lettercounter <= lettercounter + 1;
			animcounter <= 0;
			if (lettercounter == 26) lettercounter <= 0;
		end
	end
endmodule
