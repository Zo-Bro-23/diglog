# Adventure Game
## Designing
I started the design process by drawing state transition diagrams for the room and sword FSMs.

![image](https://github.com/Zo-Bro-23/diglog/blob/main/adventure/roomFSM.jpeg)
![image](https://github.com/Zo-Bro-23/diglog/blob/main/adventure/swordFSM.jpeg)

The diagram to the left of the state transition diagram explains how the input for the room FSM is a three bit number, composed of a two bit direction input and a one bit sword input. For simplification, all three inputs are not shown in the state transition diagram. For all states except DD, only the direction inputs are shown because the sword input is irrelevant. For the DD state, only the sword input is shown because the direction inputs are irrelevant. I also used letters alongside the binary inputs to make the diagram more readable. For example, `N00` is the same as `00`, but it reminds the reader that `00` corresponds for `North`. Similarly, `S0` and `S1` are just the corresponding sword inputs, and `E01`, `S10`, and `W11` are also just the same as `01`, `10`, and `11` for the direction inputs.

The sword FSM is very simple. The input to the sword FSM is the current state of the room FSM, but in order to simplify code, I ended up using the "outcome" of the room FSM as the input to the sword FSM, which is one of `Running`, `Sword`, `Live`, or `Die`. If the outcome is `Sword`, the sword FSM moves from `No` to `Yes` and stays at `Yes`. If not, nothing changes.

![image](https://github.com/Zo-Bro-23/diglog/blob/main/adventure/blockdiagram.jpeg)

This is a block diagram for the circuit of the adventure game. When decomposed, it is actually quite simple. The room FSM and sword FSM both take in inputs of the clock and reset. The sword FSM outputs `sword` as an input for the room FSM, and the room FSM outputs `outcome` as an input for the sword FSM. The decoders assist with converting the current state of the room FSM into seven human readable HEX displays, and the encoders help convert human button inputs into a two bit direction input and a reset signal.

## Developing

After I had a good idea of what the outline of the circuit should look like, I took a look at the sample code for an FSM in behavioral verilog. Since I had built the thunderbird project in behavioral (for fun) before, I was mostly familiar with the structure.

```verilog
module FSM(input in, input clk, input reset, output reg out);
reg state;
reg nextstate;
always @ (state) begin
  case (state)
    0: out = 0;
    1: out = 1;
    default: out = 0;
    endcase
end
always @ (state or in) begin
  case(state)
    0:
      if (in) nextstate = 1;
      else nextstate = 0;
    S1:
      if (in) nextstate = 1;
      else nextstate = 0;
  endcase
end
always @ (posedge clk or posedge reset) begin
  if(reset) state <= 0;
  else state <= nextstate;
end
endmodule
```

This was the basic structure of an FSM that was posted as an example on Canvas. The first block ran cases on the current state to produce outputs, the second state run cases on the current state to compute the next state, and the last block updated the current state to the next state on a clock pulse. Using this structure, I wrote a primitive version of the code for the adventure game.

```verilog
module adventure(input [1:0] SW, input [3:0] KEY, output [17:0] LEDR);
	wire [1:0] outcome;
	wire sword;

	room(SW[1:0], sword, ~KEY[2], ~KEY[3], outcome, LED);
	sword(outcome, ~KEY[2], ~KEY[3], sword);
endmodule

module sword(input [1:0] outcome, input clk, input reset, output reg sword);
	parameter SWORD = 0, RUNNING = 1, WIN = 2, DIE = 3;
	parameter NO = 0, YES = 1;
	reg state;
	reg nextstate;
	
	always @ (state) begin
		sword <= state;
	end
	
	always @ (state or outcome) begin
		case (state)
			NO:
				case (outcome)
					SWORD:
						nextstate <= YES;
				endcase
		endcase
	end
	
	always @ (posedge clk) begin
		if (reset) state <= NO;
		else state <= nextstate;
	end
endmodule

module room(input [2:0] direction, input sword, input clk, input reset, output reg [1:0] outcome, output reg [17:0] LED, output reg [3:0] state);
	parameter CC = 0, TT = 1, RR = 2, SSS = 3, DD = 4, GG = 5, VV = 6;
	parameter SWORD = 0, RUNNING = 1, WIN = 2, DIE = 3;
	parameter N = 2'b00, E = 2'b01, S = 2'b10, W = 2'b11, NIL = 7;
	reg [3:0] nextstate;
	
	always @ (state) begin
		case (state)
			CC: outcome <= RUNNING;
			TT: outcome <= RUNNING;
			RR: outcome <= RUNNING;
			SSS: outcome <= SWORD;
			DD: outcome <= RUNNING;
			GG: outcome <= DIE;
			VV: outcome <= WIN;
		endcase
		case (state)
			CC: LED <= 1;
			TT: LED <= 1;
			RR: LED <= 1;
			SSS: LED <= 8;
			DD: LED <= 1;
			GG: LED <= 2;
			VV: LED <= 4;
			default: LED <= 0;
		endcase
	end
	
	always @ (state or direction) begin
		case (state)
			CC:
				case (direction)
					E: nextstate <= TT;
					default: nextstate <= CC;
				endcase
			TT:
				case (direction)
					W: nextstate <= CC;
					S: nextstate <= RR;
					default: nextstate <= TT;
				endcase
			RR:
				case (direction)
					W: nextstate <= SSS;
					N: nextstate <= TT;
					E: nextstate <= DD;
					default: nextstate <= RR;
				endcase
			SSS:
				case (direction)
					E: nextstate <= RR;
					default: nextstate <= SSS;
				endcase
			DD:
				if (sword) nextstate <= VV;
				else nextstate <= GG;
			GG:
				nextstate <= GG;
			VV:
				nextstate <= VV;
		endcase
	end
	
	always @ (posedge clk) begin
		if (reset) state <= CC;
		else state <= nextstate;
	end
endmodule
```
