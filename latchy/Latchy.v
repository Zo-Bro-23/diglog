module Latchy(input [17:0] SW, output [17:0] LEDR);
	SR mod1(SW[0], SW[1], LEDR[0], LEDR[1]);
	DLat mod2(SW[2], SW[3], LEDR[2], LEDR[3]);
	DFF mod3(SW[4], SW[5], LEDR[4], LEDR[5]);
endmodule
