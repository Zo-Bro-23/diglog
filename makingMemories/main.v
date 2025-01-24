module memory(input [2:0] D, input [1:0] SEL, input E, output [2:0] Q);
	wire [3:0] wSEL;
	wire [3:0] rSEL;
	wire [3:0] tQ;
	decoder(SEL, E, wSEL[0], wSEL[1], wSEL[2], wSEL[3], rSEL[0], rSEL[1], rSEL[2], rSEL[3]);
	word(D, wSEL[0], tQ[0]);
	word(D, wSEL[1], tQ[1]);
	word(D, wSEL[2], tQ[2]);
	word(D, wSEL[3], tQ[3]);
	assign Q <= (tQ[0] & rSEL[0]) | (tQ[1] & rSEL[1]) | (tQ[2] & rSEL[2]) | (tQ[3] & rSEL[3]);
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
	D1 DLatch(D[0], E, Q[0]);
	D2 DLatch(D[1], E, Q[1]);
	D3 DLatch(D[2], E, Q[2]);
endmodule

module DLatch(input D, input E, output reg Q);
	always @ (D or E) begin
		if (E) Q <= D;
		else Q <= Q;
	end
endmodule
