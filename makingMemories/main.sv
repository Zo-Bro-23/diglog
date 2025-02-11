module memory(input [2:0] D, input [1:0] SEL, input E, output [2:0] Q);
	wire [3:0] wSEL; // Write select
	wire [3:0] rSEL; // Read select
	wire [3:0] [2:0] rPATCH; // Nested array for comparing values
	wire [3:0] [2:0] tQ; // Temporary output as nested array for computation
	// It is possible to use a 12 bit bus and uncomplicate things, but that wouldn't be fun
	decoder(SEL, E, rSEL, wSEL); // Runs the decoder to convert 2 bit select to 4 bit one-hot select buses
	word WRDINST [3:0] (D, wSEL, tQ); // Creates multiple words and pushes the output to tQ (nested array)
	patch PATINST [3:0] (rSEL, tQ, rPATCH); // Uses the patch module to loop through the nested array and compare the elemental arrays
	assign Q = rPATCH[0] | rPATCH[1] | rPATCH[2] | rPATCH[3]; // Have to manually compare nested array since FOR loop and GENERATE statements are strictly prohibited
endmodule

module patch(input value, input [2:0] wSTATE, output [2:0] out); // Essentially simulating a FOR loop
	wire [2:0] rPICK;
	assign rPICK = {3{value}}; // Duplicates rSEL so that it can be compared to words
	assign out = wSTATE & rPICK; // Compares to the word to see if it is selected
endmodule

module decoder(input [1:0] SEL, input E, output reg [3:0] rSEL, output [3:0] wSEL);	
	always @ (SEL or E) begin
		case (SEL) // Converts a 2 bit select signal to a 4 bit one-hot read select
			0: rSEL <= 4'b0001;
			1: rSEL <= 4'b0010;
			2: rSEL <= 4'b0100;
			3: rSEL <= 4'b1000;
			// DONT DO 32 LINE CODE -- 32 LINE CODE BAD
		endcase
	end
	assign wSEL = rSEL & {4{E}}; // Use the read select and write enable to create a write select
endmodule

module word(input [2:0] D, input E, output [2:0] Q);
	DDLatch DINST [2:0] (D, E, Q); // Use clever syntax to create a word
endmodule

module DDLatch(input D, input E, output reg Q);
	always @ (D or E) begin // DLatch!!
		if (E) Q <= D;
		else Q <= Q;
	end
endmodule
