module Latchy(input [17:0] SW, output [17:0] LEDR);
	SR mod1(SW[0], SW[1], LEDR[0], LEDR[1]);
endmodule
