module Adder(SW, HEX0, HEX1, LEDR);
	input [17:0] SW;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [17:0] LEDR;
	wire[4:0] sum;
	wire[4:0] carry;
	assign sum[0]=SW[0]^SW[14];
	assign carry[0]=SW[0]&SW[14];
	assign sum[1]=(SW[1]^SW[15])^carry[0];
	assign carry[1]=(carry[0]&SW[1])|(carry[0]&SW[15])|(SW[1]&SW[15]);
	assign sum[2]=(SW[2]^SW[16])^carry[1];
	assign carry[2]=(carry[1]&SW[2])|(carry[1]&SW[16])|(SW[2]&SW[16]);
	assign sum[3]=(SW[3]^SW[17])^carry[2];
	assign carry[3]=(carry[2]&SW[3])|(carry[2]&SW[17])|(SW[3]&SW[17]);
	assign LEDR[0]=sum[0];
	assign LEDR[1]=sum[1];
	assign LEDR[2]=sum[2];
	assign LEDR[3]=sum[3];
	assign LEDR[4]=carry[3];
	
	assign HEX0[0]=(sum[0]&~sum[1]&~sum[2]&~sum[3])|(~sum[0]&~sum[1]&sum[2]&~sum[3])|(sum[0]&sum[1]&~sum[2]&sum[3])|(sum[0]&~sum[1]&sum[2]&sum[3]);
	assign HEX0[1]=(sum[0]&~sum[1]&~sum[2]&~sum[3])|(sum[0]&~sum[1]&sum[2]&~sum[3])|(~sum[0]&sum[1]&sum[2]&~sum[3])|(sum[0]&sum[1]&~sum[2]&sum[3])|(~sum[0]&~sum[1]&sum[2]&sum[3])|(~sum[0]&sum[1]&sum[2]&sum[3])|(sum[0]&sum[1]&sum[2]&sum[3]);
	assign HEX0[2]=(sum[0]&~sum[1]&~sum[2]&~sum[3])|(~sum[0]&sum[1]&~sum[2]&~sum[3])|(~sum[0]&~sum[1]&sum[2]&sum[3])|(~sum[0]&sum[1]&sum[2]&sum[3])|(sum[0]&sum[1]&sum[2]&sum[3]);
	assign HEX0[3]=(sum[0]&~sum[1]&~sum[2]&~sum[3])|(~sum[0]&~sum[1]&sum[2]&~sum[3])|(sum[0]&sum[1]&sum[2]&~sum[3])|(sum[0]&~sum[1]&~sum[2]&sum[3])|(~sum[0]&sum[1]&~sum[2]&sum[3])|(sum[0]&sum[1]&sum[2]&sum[3]);
	assign HEX0[4]=(sum[0]&sum[1]&~sum[2]&~sum[3])|(~sum[0]&~sum[1]&sum[2]&~sum[3])|(sum[0]&~sum[1]&sum[2]&~sum[3])|(sum[0]&sum[1]&sum[2]&~sum[3])|(sum[0]&~sum[1]&~sum[2]&sum[3]);
	assign HEX0[5]=(~sum[0]&sum[1]&~sum[2]&~sum[3])|(sum[0]&sum[1]&~sum[2]&~sum[3])|(sum[0]&~sum[1]&sum[2]&sum[3]);
	assign HEX0[6]=(~sum[0]&~sum[1]&~sum[2]&~sum[3])|(sum[0]&~sum[1]&~sum[2]&~sum[3])|(sum[0]&sum[1]&sum[2]&~sum[3])|(~sum[0]&~sum[1]&sum[2]&sum[3]);

	assign HEX1[0]=(carry[3]&~0&~0&~0)|(~carry[3]&~0&0&~0)|(carry[3]&0&~0&0)|(carry[3]&~0&0&0);
	assign HEX1[1]=(carry[3]&~0&~0&~0)|(carry[3]&~0&0&~0)|(~carry[3]&0&0&~0)|(carry[3]&0&~0&0)|(~carry[3]&~0&0&0)|(~carry[3]&0&0&0)|(carry[3]&0&0&0);
	assign HEX1[2]=(carry[3]&~0&~0&~0)|(~carry[3]&0&~0&~0)|(~carry[3]&~0&0&0)|(~carry[3]&0&0&0)|(carry[3]&0&0&0);
	assign HEX1[3]=(carry[3]&~0&~0&~0)|(~carry[3]&~0&0&~0)|(carry[3]&0&0&~0)|(carry[3]&~0&~0&0)|(~carry[3]&0&~0&0)|(carry[3]&0&0&0);
	assign HEX1[4]=(carry[3]&0&~0&~0)|(~carry[3]&~0&0&~0)|(carry[3]&~0&0&~0)|(carry[3]&0&0&~0)|(carry[3]&~0&~0&0);
	assign HEX1[5]=(~carry[3]&0&~0&~0)|(carry[3]&0&~0&~0)|(carry[3]&~0&0&0);
	assign HEX1[6]=(~carry[3]&~0&~0&~0)|(carry[3]&~0&~0&~0)|(carry[3]&0&0&~0)|(~carry[3]&~0&0&0);
endmodule
