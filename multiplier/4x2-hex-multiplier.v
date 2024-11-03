module Multiplier(SW, HEX0, HEX1, LEDR);
	input [17:0] SW;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [17:0] LEDR;
	wire[6:0] sum;
	wire[6:0] carry;
	wire[6:0] product0;
	wire[6:0] product1;
	wire[6:0] product2;
	wire[6:0] product3;
	
	assign product0[0]=SW[0]&SW[14];
	assign product0[1]=SW[0]&SW[15];
	assign product0[2]=SW[0]&SW[16];
	assign product0[3]=SW[0]&SW[17];
	assign product0[4]=0;
	assign product0[5]=0;
	assign product0[6]=0;
	
	assign product1[0]=0;
	assign product1[1]=SW[1]&SW[14];
	assign product1[2]=SW[1]&SW[15];
	assign product1[3]=SW[1]&SW[16];
	assign product1[4]=SW[1]&SW[17];
	assign product1[5]=0;
	assign product1[6]=0;
	
	assign product2[0]=0;
	assign product2[1]=0;
	assign product2[2]=SW[2]&SW[14];
	assign product2[3]=SW[2]&SW[15];
	assign product2[4]=SW[2]&SW[16];
	assign product2[5]=SW[2]&SW[17];
	assign product2[6]=0;
	
	assign product3[0]=0;
	assign product3[1]=0;
	assign product3[2]=0;
	assign product3[3]=SW[3]&SW[14];
	assign product3[4]=SW[3]&SW[15];
	assign product3[5]=SW[3]&SW[16];
	assign product3[6]=SW[3]&SW[17];
	
	assign sum[0]=product0[0]^product1[0];
	assign carry[0]=product0[0]&product1[0];
	assign sum[1]=(product0[1]^product1[1])^carry[0];
	assign carry[1]=(carry[0]&product0[1])|(carry[0]&product1[1])|(product0[1]&product1[1]);
	assign sum[2]=(product0[2]^product1[2])^carry[1];
	assign carry[2]=(carry[1]&product0[2])|(carry[1]&product1[2])|(product0[2]&product1[2]);
	assign sum[3]=(product0[3]^product1[3])^carry[2];
	assign carry[3]=(carry[2]&product0[3])|(carry[2]&product1[3])|(product0[3]&product1[3]);
	assign sum[4]=(product0[4]^product1[4])^carry[3];
	assign carry[4]=(carry[3]&product0[4])|(carry[3]&product1[4])|(product0[4]&product1[4]);
	assign LEDR[0]=sum[0];
	assign LEDR[1]=sum[1];
	assign LEDR[2]=sum[2];
	assign LEDR[3]=sum[3];
	assign LEDR[4]=sum[4];
	assign LEDR[5]=sum[5];
	
	assign HEX0[0]=(sum[0]&~sum[1]&~sum[2]&~sum[3])|(~sum[0]&~sum[1]&sum[2]&~sum[3])|(sum[0]&sum[1]&~sum[2]&sum[3])|(sum[0]&~sum[1]&sum[2]&sum[3]);
	assign HEX0[1]=(sum[0]&~sum[1]&~sum[2]&~sum[3])|(sum[0]&~sum[1]&sum[2]&~sum[3])|(~sum[0]&sum[1]&sum[2]&~sum[3])|(sum[0]&sum[1]&~sum[2]&sum[3])|(~sum[0]&~sum[1]&sum[2]&sum[3])|(~sum[0]&sum[1]&sum[2]&sum[3])|(sum[0]&sum[1]&sum[2]&sum[3]);
	assign HEX0[2]=(sum[0]&~sum[1]&~sum[2]&~sum[3])|(~sum[0]&sum[1]&~sum[2]&~sum[3])|(~sum[0]&~sum[1]&sum[2]&sum[3])|(~sum[0]&sum[1]&sum[2]&sum[3])|(sum[0]&sum[1]&sum[2]&sum[3]);
	assign HEX0[3]=(sum[0]&~sum[1]&~sum[2]&~sum[3])|(~sum[0]&~sum[1]&sum[2]&~sum[3])|(sum[0]&sum[1]&sum[2]&~sum[3])|(sum[0]&~sum[1]&~sum[2]&sum[3])|(~sum[0]&sum[1]&~sum[2]&sum[3])|(sum[0]&sum[1]&sum[2]&sum[3]);
	assign HEX0[4]=(sum[0]&sum[1]&~sum[2]&~sum[3])|(~sum[0]&~sum[1]&sum[2]&~sum[3])|(sum[0]&~sum[1]&sum[2]&~sum[3])|(sum[0]&sum[1]&sum[2]&~sum[3])|(sum[0]&~sum[1]&~sum[2]&sum[3]);
	assign HEX0[5]=(~sum[0]&sum[1]&~sum[2]&~sum[3])|(sum[0]&sum[1]&~sum[2]&~sum[3])|(sum[0]&~sum[1]&sum[2]&sum[3]);
	assign HEX0[6]=(~sum[0]&~sum[1]&~sum[2]&~sum[3])|(sum[0]&~sum[1]&~sum[2]&~sum[3])|(sum[0]&sum[1]&sum[2]&~sum[3])|(~sum[0]&~sum[1]&sum[2]&sum[3]);

	assign HEX1[0]=(sum[4]&~carry[4]&~0&~0)|(~sum[4]&~carry[4]&0&~0)|(sum[4]&carry[4]&~0&0)|(sum[4]&~carry[4]&0&0);
	assign HEX1[1]=(sum[4]&~carry[4]&~0&~0)|(sum[4]&~carry[4]&0&~0)|(~sum[4]&carry[4]&0&~0)|(sum[4]&carry[4]&~0&0)|(~sum[4]&~carry[4]&0&0)|(~sum[4]&carry[4]&0&0)|(sum[4]&carry[4]&0&0);
	assign HEX1[2]=(sum[4]&~carry[4]&~0&~0)|(~sum[4]&carry[4]&~0&~0)|(~sum[4]&~carry[4]&0&0)|(~sum[4]&carry[4]&0&0)|(sum[4]&carry[4]&0&0);
	assign HEX1[3]=(sum[4]&~carry[4]&~0&~0)|(~sum[4]&~carry[4]&0&~0)|(sum[4]&carry[4]&0&~0)|(sum[4]&~carry[4]&~0&0)|(~sum[4]&carry[4]&~0&0)|(sum[4]&carry[4]&0&0);
	assign HEX1[4]=(sum[4]&carry[4]&~0&~0)|(~sum[4]&~carry[4]&0&~0)|(sum[4]&~carry[4]&0&~0)|(sum[4]&carry[4]&0&~0)|(sum[4]&~carry[4]&~0&0);
	assign HEX1[5]=(~sum[4]&carry[4]&~0&~0)|(sum[4]&carry[4]&~0&~0)|(sum[4]&~carry[4]&0&0);
	assign HEX1[6]=(~sum[4]&~carry[4]&~0&~0)|(sum[4]&~carry[4]&~0&~0)|(sum[4]&carry[4]&0&~0)|(~sum[4]&~carry[4]&0&0);

endmodule
