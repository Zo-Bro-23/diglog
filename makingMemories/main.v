module memory(input [2:0] D, input [1:0] SEL, input E, output [2:0] Q);
	wire [3:0] wSEL;
	wire [3:0] rSEL;
	wire [2:0] tQ [3:0];
	decoder(SEL, E, wSEL[0], wSEL[1], wSEL[2], wSEL[3], rSEL[0], rSEL[1], rSEL[2], rSEL[3]);
	word WRDINST [3:0] (D, wSEL, tQ);
	//assign Q = (tQ[0] & {4{rSEL[0]}}) | (tQ[1] & {4{rSEL[1]}}) | (tQ[2] & {4{rSEL[2]}}) | (tQ[3] & {4{rSEL[3]}});
	assign Q = |(tQ & {3{rSEL}});
endmodule

module decoder(input [1:0] SEL, input E, output reg A, B, C, D, output reg rA, rB, rC, rD);
	always @ (SEL or E) begin
		case (SEL)
			0: begin
				A <= E;
				B <= 0;
				C <= 0;
				D <= 0;
				rA <= 1;
				rB <= 0;
				rC <= 0;
				rD <= 0;
			end
			1: begin
				A <= 0;
				B <= E;
				C <= 0;
				D <= 0;
				rA <= 0;
				rB <= 1;
				rC <= 0;
				rD <= 0;
			end
			2: begin
				A <= 0;
				B <= 0;
				C <= E;
				D <= 0;
				rA <= 0;
				rB <= 0;
				rC <= 1;
				rD <= 0;
			end
			3: begin
				A <= 0;
				B <= 0;
				C <= 0;
				D <= E;
				rA <= 0;
				rB <= 0;
				rC <= 0;
				rD <= 1;
			end
		endcase
	end
endmodule

module word(input [2:0] D, input E, output [2:0] Q);
	DDLatch DINST [2:0] (D, E, Q);
endmodule

module DDLatch(input D, input E, output reg Q);
	always @ (D or E) begin
		if (E) Q <= D;
		else Q <= Q;
	end
endmodule
