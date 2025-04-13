module distance(inout reg [29:27] GPIO, input [2:0] SW, input CLOCK_50, output reg [17:0] LEDR);
	reg [24:0] counter = 0;
	reg [17:0] rec = 0;
	reg [0:0] ready = 0;
	always @ (posedge CLOCK_50) begin
		counter <= counter + 1;
		if (!ready && (GPIO[27] == 1)) begin
			rec <= 0;
			ready <= 1;
		end
		if (ready && (GPIO[27] == 1)) begin
			rec <= rec + 1;
		end
		if (ready && (GPIO[27] == 0)) begin
			ready <= 0;
		end
		if (counter == 500) begin
			GPIO[29] <= 0;
		end
		if (counter == 100000) begin
			counter <= 0;
			GPIO[29] <= 1;
		end
		LEDR[17:0] <= rec;
	end
endmodule
