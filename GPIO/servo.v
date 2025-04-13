module servo(inout reg [29:27] GPIO, input [2:0] SW, input CLOCK_50);
	reg [24:0] counter = 0;
	reg [24:0] secounter = 0;
	reg [24:0] set = 25000;
	always @ (posedge CLOCK_50) begin
		GPIO[27] <= 1;
		counter <= counter + 1;
		if (counter == set) GPIO[29] <= 0;
		if (counter == 1000000) begin
			counter <= 0;
			secounter <= secounter + 1;
			GPIO[29] <= 1;
		end
		if (secounter == 50) begin
			if (set == 125000) set <= 25000;
			else set <= set + 10000;
			secounter <= 0;
		end
	end
endmodule
