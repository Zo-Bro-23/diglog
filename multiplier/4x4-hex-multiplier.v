module Multiplier(SW, HEX0, HEX1, HEX2, LEDR, LEDG);
	input [17:0] SW;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [17:0] LEDR;
	output [7:0] LEDG;
	wire[7:0] sum0;
	wire[7:0] carry0;
	wire[7:0] sum1;
	wire[7:0] carry1;
	wire[8:0] sum2;
	wire[7:0] carry2;
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
	
	assign sum0[0]=product0[0]^product1[0];
	assign carry0[0]=product0[0]&product1[0];
	assign sum0[1]=(product0[1]^product1[1])^carry0[0];
	assign carry0[1]=(carry0[0]&product0[1])|(carry0[0]&product1[1])|(product0[1]&product1[1]);
	assign sum0[2]=(product0[2]^product1[2])^carry0[1];
	assign carry0[2]=(carry0[1]&product0[2])|(carry0[1]&product1[2])|(product0[2]&product1[2]);
	assign sum0[3]=(product0[3]^product1[3])^carry0[2];
	assign carry0[3]=(carry0[2]&product0[3])|(carry0[2]&product1[3])|(product0[3]&product1[3]);
	assign sum0[4]=(product0[4]^product1[4])^carry0[3];
	assign carry0[4]=(carry0[3]&product0[4])|(carry0[3]&product1[4])|(product0[4]&product1[4]);
	assign sum0[5]=(product0[5]^product1[5])^carry0[4];
	assign carry0[5]=(carry0[4]&product0[5])|(carry0[4]&product1[5])|(product0[5]&product1[5]);
	assign sum0[6]=(product0[6]^product1[6])^carry0[5];
	assign sum0[7]=(carry0[5]^product0[6])|(carry0[5]&product1[6])|(product0[6]&product1[6]);
	
	assign sum1[0]=product2[0]^product3[0];
	assign carry1[0]=product2[0]&product3[0];
	assign sum1[1]=(product2[1]^product3[1])^carry1[0];
	assign carry1[1]=(carry1[0]&product2[1])|(carry1[0]&product3[1])|(product2[1]&product3[1]);
	assign sum1[2]=(product2[2]^product3[2])^carry1[1];
	assign carry1[2]=(carry1[1]&product2[2])|(carry1[1]&product3[2])|(product2[2]&product3[2]);
	assign sum1[3]=(product2[3]^product3[3])^carry1[2];
	assign carry1[3]=(carry1[2]&product2[3])|(carry1[2]&product3[3])|(product2[3]&product3[3]);
	assign sum1[4]=(product2[4]^product3[4])^carry1[3];
	assign carry1[4]=(carry1[3]&product2[4])|(carry1[3]&product3[4])|(product2[4]&product3[4]);
	assign sum1[5]=(product2[5]^product3[5])^carry1[4];
	assign carry1[5]=(carry1[4]&product2[5])|(carry1[4]&product3[5])|(product2[5]&product3[5]);
	assign sum1[6]=(product2[6]^product3[6])^carry1[5];
	assign sum1[7]=(carry1[5]^product2[6])|(carry1[5]&product3[6])|(product2[6]&product3[6]);
	
	assign sum2[0]=sum0[0]^sum1[0];
	assign carry2[0]=sum0[0]&sum1[0];
	assign sum2[1]=(sum0[1]^sum1[1])^carry2[0];
	assign carry2[1]=(carry2[0]&sum0[1])|(carry2[0]&sum1[1])|(sum0[1]&sum1[1]);
	assign sum2[2]=(sum0[2]^sum1[2])^carry2[1];
	assign carry2[2]=(carry2[1]&sum0[2])|(carry2[1]&sum1[2])|(sum0[2]&sum1[2]);
	assign sum2[3]=(sum0[3]^sum1[3])^carry2[2];
	assign carry2[3]=(carry2[2]&sum0[3])|(carry2[2]&sum1[3])|(sum0[3]&sum1[3]);
	assign sum2[4]=(sum0[4]^sum1[4])^carry2[3];
	assign carry2[4]=(carry2[3]&sum0[4])|(carry2[3]&sum1[4])|(sum0[4]&sum1[4]);
	assign sum2[5]=(sum0[5]^sum1[5])^carry2[4];
	assign carry2[5]=(carry2[4]&sum0[5])|(carry2[4]&sum1[5])|(sum0[5]&sum1[5]);
	assign sum2[6]=(sum0[6]^sum1[6])^carry2[5];
	assign carry2[6]=(carry2[5]^sum0[6])|(carry2[5]&sum1[6])|(sum0[6]&sum1[6]);
	assign sum2[7]=(sum0[7]^sum1[7])^carry2[6];
	assign sum2[8]=(carry2[6]^sum0[7])|(carry2[6]&sum1[7])|(sum0[7]&sum1[7]);
	
	assign LEDR[0]=sum2[0];
	assign LEDR[1]=sum2[1];
	assign LEDR[2]=sum2[2];
	assign LEDR[3]=sum2[3];
	assign LEDR[4]=sum2[4];
	assign LEDR[5]=sum2[5];
	assign LEDR[6]=sum2[6];
	assign LEDR[7]=sum2[7];
	assign LEDR[8]=sum2[8];
	
	assign LEDG[0]=sum1[0];
	assign LEDG[1]=sum1[1];
	assign LEDG[2]=sum1[2];
	assign LEDG[3]=sum1[3];
	assign LEDG[4]=sum1[4];
	assign LEDG[5]=sum1[5];
	assign LEDG[6]=sum1[6];
	assign LEDG[7]=sum1[7];
	
	assign LEDR[9]=sum0[0];
	assign LEDR[10]=sum0[1];
	assign LEDR[11]=sum0[2];
	assign LEDR[12]=sum0[3];
	assign LEDR[13]=sum0[4];
	assign LEDR[14]=sum0[5];
	assign LEDR[15]=sum0[6];
	assign LEDR[16]=sum0[7];
	
	assign HEX0[0]=(sum2[0]&~sum2[1]&~sum2[2]&~sum2[3])|(~sum2[0]&~sum2[1]&sum2[2]&~sum2[3])|(sum2[0]&sum2[1]&~sum2[2]&sum2[3])|(sum2[0]&~sum2[1]&sum2[2]&sum2[3]);
	assign HEX0[1]=(sum2[0]&~sum2[1]&~sum2[2]&~sum2[3])|(sum2[0]&~sum2[1]&sum2[2]&~sum2[3])|(~sum2[0]&sum2[1]&sum2[2]&~sum2[3])|(sum2[0]&sum2[1]&~sum2[2]&sum2[3])|(~sum2[0]&~sum2[1]&sum2[2]&sum2[3])|(~sum2[0]&sum2[1]&sum2[2]&sum2[3])|(sum2[0]&sum2[1]&sum2[2]&sum2[3]);
	assign HEX0[2]=(sum2[0]&~sum2[1]&~sum2[2]&~sum2[3])|(~sum2[0]&sum2[1]&~sum2[2]&~sum2[3])|(~sum2[0]&~sum2[1]&sum2[2]&sum2[3])|(~sum2[0]&sum2[1]&sum2[2]&sum2[3])|(sum2[0]&sum2[1]&sum2[2]&sum2[3]);
	assign HEX0[3]=(sum2[0]&~sum2[1]&~sum2[2]&~sum2[3])|(~sum2[0]&~sum2[1]&sum2[2]&~sum2[3])|(sum2[0]&sum2[1]&sum2[2]&~sum2[3])|(sum2[0]&~sum2[1]&~sum2[2]&sum2[3])|(~sum2[0]&sum2[1]&~sum2[2]&sum2[3])|(sum2[0]&sum2[1]&sum2[2]&sum2[3]);
	assign HEX0[4]=(sum2[0]&sum2[1]&~sum2[2]&~sum2[3])|(~sum2[0]&~sum2[1]&sum2[2]&~sum2[3])|(sum2[0]&~sum2[1]&sum2[2]&~sum2[3])|(sum2[0]&sum2[1]&sum2[2]&~sum2[3])|(sum2[0]&~sum2[1]&~sum2[2]&sum2[3]);
	assign HEX0[5]=(~sum2[0]&sum2[1]&~sum2[2]&~sum2[3])|(sum2[0]&sum2[1]&~sum2[2]&~sum2[3])|(sum2[0]&~sum2[1]&sum2[2]&sum2[3]);
	assign HEX0[6]=(~sum2[0]&~sum2[1]&~sum2[2]&~sum2[3])|(sum2[0]&~sum2[1]&~sum2[2]&~sum2[3])|(sum2[0]&sum2[1]&sum2[2]&~sum2[3])|(~sum2[0]&~sum2[1]&sum2[2]&sum2[3]);

	assign HEX1[0]=(sum2[4]&~sum2[5]&~sum2[6]&~sum2[7])|(~sum2[4]&~sum2[5]&sum2[6]&~sum2[7])|(sum2[4]&sum2[5]&~sum2[6]&sum2[7])|(sum2[4]&~sum2[5]&sum2[6]&sum2[7]);
	assign HEX1[1]=(sum2[4]&~sum2[5]&~sum2[6]&~sum2[7])|(sum2[4]&~sum2[5]&sum2[6]&~sum2[7])|(~sum2[4]&sum2[5]&sum2[6]&~sum2[7])|(sum2[4]&sum2[5]&~sum2[6]&sum2[7])|(~sum2[4]&~sum2[5]&sum2[6]&sum2[7])|(~sum2[4]&sum2[5]&sum2[6]&sum2[7])|(sum2[4]&sum2[5]&sum2[6]&sum2[7]);
	assign HEX1[2]=(sum2[4]&~sum2[5]&~sum2[6]&~sum2[7])|(~sum2[4]&sum2[5]&~sum2[6]&~sum2[7])|(~sum2[4]&~sum2[5]&sum2[6]&sum2[7])|(~sum2[4]&sum2[5]&sum2[6]&sum2[7])|(sum2[4]&sum2[5]&sum2[6]&sum2[7]);
	assign HEX1[3]=(sum2[4]&~sum2[5]&~sum2[6]&~sum2[7])|(~sum2[4]&~sum2[5]&sum2[6]&~sum2[7])|(sum2[4]&sum2[5]&sum2[6]&~sum2[7])|(sum2[4]&~sum2[5]&~sum2[6]&sum2[7])|(~sum2[4]&sum2[5]&~sum2[6]&sum2[7])|(sum2[4]&sum2[5]&sum2[6]&sum2[7]);
	assign HEX1[4]=(sum2[4]&sum2[5]&~sum2[6]&~sum2[7])|(~sum2[4]&~sum2[5]&sum2[6]&~sum2[7])|(sum2[4]&~sum2[5]&sum2[6]&~sum2[7])|(sum2[4]&sum2[5]&sum2[6]&~sum2[7])|(sum2[4]&~sum2[5]&~sum2[6]&sum2[7]);
	assign HEX1[5]=(~sum2[4]&sum2[5]&~sum2[6]&~sum2[7])|(sum2[4]&sum2[5]&~sum2[6]&~sum2[7])|(sum2[4]&~sum2[5]&sum2[6]&sum2[7]);
	assign HEX1[6]=(~sum2[4]&~sum2[5]&~sum2[6]&~sum2[7])|(sum2[4]&~sum2[5]&~sum2[6]&~sum2[7])|(sum2[4]&sum2[5]&sum2[6]&~sum2[7])|(~sum2[4]&~sum2[5]&sum2[6]&sum2[7]);

	assign HEX2[0]=(sum2[8]&~0&~0&~0)|(~sum2[8]&~0&0&~0)|(sum2[8]&0&~0&0)|(sum2[8]&~0&0&0);
	assign HEX2[1]=(sum2[8]&~0&~0&~0)|(sum2[8]&~0&0&~0)|(~sum2[8]&0&0&~0)|(sum2[8]&0&~0&0)|(~sum2[8]&~0&0&0)|(~sum2[8]&0&0&0)|(sum2[8]&0&0&0);
	assign HEX2[2]=(sum2[8]&~0&~0&~0)|(~sum2[8]&0&~0&~0)|(~sum2[8]&~0&0&0)|(~sum2[8]&0&0&0)|(sum2[8]&0&0&0);
	assign HEX2[3]=(sum2[8]&~0&~0&~0)|(~sum2[8]&~0&0&~0)|(sum2[8]&0&0&~0)|(sum2[8]&~0&~0&0)|(~sum2[8]&0&~0&0)|(sum2[8]&0&0&0);
	assign HEX2[4]=(sum2[8]&0&~0&~0)|(~sum2[8]&~0&0&~0)|(sum2[8]&~0&0&~0)|(sum2[8]&0&0&~0)|(sum2[8]&~0&~0&0);
	assign HEX2[5]=(~sum2[8]&0&~0&~0)|(sum2[8]&0&~0&~0)|(sum2[8]&~0&0&0);
	assign HEX2[6]=(~sum2[8]&~0&~0&~0)|(sum2[8]&~0&~0&~0)|(sum2[8]&0&0&~0)|(~sum2[8]&~0&0&0);
endmodule
