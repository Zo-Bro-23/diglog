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

module room(input [1:0] direction, input sword, input clk, input reset, output reg outcome, output reg [17:0] LED);
	parameter CC = 0, TT = 1, RR = 2, SSS = 3, DD = 4, GG = 5, VV = 6;
	parameter SWORD = 0, RUNNING = 1, WIN = 2, DIE = 3;
	parameter N = 2'b00, E = 2'b01, S = 2'b10, W = 2'b11;
	reg [3:0] state;
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
		endcase
	end
	
	always @ (posedge clk) begin
		if (reset) state <= CC;
		else state <= nextstate;
	end
endmodule
```
I ran it on the FPGA, with the switches as directional input, the buttons (KEY) as clock and reset inputs, and the LEDs as output for the outcome of the game. It did not work.

## Debugging
The first thing I realized was that I needed a better output system in order to debug it properly on the FPGA. I added code to display the current state on the LEDs, but the game would only move between the first two states. I added the `default: nextstate <= state;` lines to all the cases, and it seemed to stabilize the behavior of the game, but it would now move back to the first state instead of moving on to the third state. Invalid inputs were all handled properly. I played around a lot with the behavioral verilog, thinking it was the syntax, but it was all to no avail. I replaced everything with the third room, and the third room was still outputed as the first room. I tried many things for many days, and nothing worked. Finally, I realized that my state had to be a bus instead of a single output or register. The same was true for the outcome. The reason it took me so long to pinpoint this error is because this was my first time using parameters, and because my parameters were all encoded using decimal numbers, it didn't occur to me that my registers still had to be binary busses of the appropriate dimensions. This is why the third room was seen as the first room, since `0` and `2` both share a single's digit.

Now my game seemed to work properly, so I started thinking about making the interface user-friendly. I had a eureka moment when I was thinking about how to simplify code for HEX displays and realized that the outputs could be written in decimal numbers instead of long strings such as `7'b0101100`. I created a [cheatsheet](https://github.com/Zo-Bro-23/diglog/blob/main/adventure/cheatsheet.json) for all the possible characters, and displayed the current room using a HEX display. My game worked, apart from two problems. The last room seemed to be displayed using `b`, which was not a valid option, and the game seemed to end up at `b` regardless of the sword. Thinking this was a HEX encoding mistake and that `b` was victory, I figured that the sword FSM was not working correctly.

After debugging for a while, I realized that `b` was neither `v` nor `g`, nor any of the valid room display options that I was outputting. Confused, I thought about possible issues, and realized that there might be an issue in not having state cases for VV and GG. So I added `VV: nextstate <= VV;` and `GG: nextstate <= GG;` and it worked! I realized that `b` was an average of all the possible outputs, and so the FPGA was doing a weird thing of being in all states at once when it did not know which state to go to. This was valuable information, since it meant that a case statement without all cases being accounted for would lead to unexpected behavior. I realized that the sword FSM was indeed not working properly, and so I added a `YES: nextstate <= YES;` statement and a `default: nextstate <= NO;` within the NO case. Of course, I can always just do `default: nextstate <= state;`, but since most cases were accounted for, it was easier to just do specific cases.

## Extension
After this, the game pretty much worked as expected. I tried simplifying my code from the previous project to make the clock automatic, but I was confused about my syntax, so I compared code with Kevin. His code seemed cleaner and more compact, so I ended up using his code for that section.

```verilog
module clock(input clk, output reg pulse);
	reg [23:0] Q;
	always @ (posedge clk) begin
		Q <= Q + 1;
		if (&Q) pulse <= !pulse;
	end
endmodule
```

I was surprised that it would work without a reset, but I think behavioral verilog equates an unknown signal to a value of `0`. Furthermore, Griffin was showing me his work, and I realized that his user interface was really really intuitive. He had four buttons for the directions, and pressing all four together would reset the game. He also had a HEX display to show the available options for direction, such as an `L` for both west and south, and a `1` for only east. I copied these two ideas, although I wrote my own code.

```verilog
always @ (buttons) begin
		reset = 0;
		case (buttons)
			4'b1110: direction <= 1;
			4'b1101: direction <= 2;
			4'b1011: direction <= 0;
			4'b0111: direction <= 3;
			4'b0000: reset <= 1;
		endcase
	end
```

This did not work as expected, and the room would change when a button was pressed, but it would then go back to the original room when released. I debugged it by outputting the direction input to LEDs from within the room FSM, and I realized that the default was `00` when nothing was inputted, equating it to `North`. (This is what I mentioned earlier about no signal being the same as a signal of `0`) I realized that I couldn't really do anything without making the direction bus bigger, so I made the direction bus 3 bits and added the line `default: direction <= 7;`. This seemed to make it work.

The HEX display outputs were just tedious to do, and my decimal code simplified it by a huge amount. I ended up using binary outputs only for the direction HEX since not all directions were valid characters. Finally, I was at a place where I was happy with my code.

https://github.com/Zo-Bro-23/diglog/blob/8ec5a7721090f979a8a3f98506dad71af933b3d4/adventure/adventure.v#L1-L197

## Waveform
![image](https://github.com/Zo-Bro-23/diglog/blob/main/adventure/waveform.png)

The waveform is pretty intuitive to understand. The first four lines signify the four direction inputs `(East, South, North, West)`, and the LEDs signify the outcome `(Running, Die, Live, Sword)`. The state outputs are encoded in binary, with the rooms `(CC, TT, RR, SSS, DD, GG, and VV)` corresponding to `(0, 1, 2, 3, 4, 5, and 6)`.

The test resets the game by pressing all the buttons, and then goes East. The state changes from 0 to 1. Going South changes it from 1 to 2. Going East changes it first to 4 (DD) then to 5 (GG), and the outcome becomes Die. Next, the game is reset. Inputs go `East > South > West > East > East`, and the rooms go `0, 1, 2, 3, 4, 6` which corresponds to `CC, TT, RR, SSS, DD, VV`. The outcomes go `Run > Sword > Run > Live`.

## RTL
![image](https://github.com/Zo-Bro-23/diglog/blob/main/adventure/artl1.png)

This looks almost identical to my block diagram. I was initially confused by the 15-bit "DATA" used in the Decoder and Muxes. I then realized that there were 16 possibilities for the various button combinations, which is likely what this is. For example, East would be `1110`, (since the buttons are inverted), which would correspond to `14` or `E` in HEX. However, this is only four bits, and not sixteen, so I am still slightly confused (direction is a 3 bit output, which might have something to do with this). Also, I don't fully understand why the decoder is used for resetting, while muxes are used for the direction input when the behavioral code is essentially the same for both those functions. Either way, three D-latches pass on these outputs as inputs to the room FSM, and connections between the room and sword FSMs are as expected. The room FSM outputs into decoders which are off-screen. I took a look, and it's just a very long list of decoders with complicated combinational logic that represents the HEX display outputs.

![image](https://github.com/Zo-Bro-23/diglog/blob/main/adventure/artl2.png)

This RTL diagram looks exactly like the diagram used in the previous project for an automatic counter. The "Add" element works on a 23 bus until they are all one (adding one each clock pulse), which then goes through an AND gate as an enable for a D flip-flop that "flips" the pulse.

![image](https://github.com/Zo-Bro-23/diglog/blob/main/adventure/artl3.png)

The sword FSM diagram is quite simple, and makes sense at the large scale. It is performing some evaluation on the input from the room FSM (Equal0) and using a Decoder to set the next state to the appropriate value. This is then getting passed on to the current state using a flip flop.

![image](https://github.com/Zo-Bro-23/diglog/blob/main/adventure/artl4.png)

The room FSM is the most complicated part of the circuit. Simplifying it and looking at it from the top down, however, the basic structure of an FSM is apparent. The decoders and the equals are performing the combinational logic evaluation in order to the determine the next state using the current state and inputs. The muxes along with the flip flop is then setting the current state to the next state. Finally, the second set of muxes as well as the decoders which are off-screen are used to determine the complicated outputs being sent to the HEX dispalys. I still don't fully understand the DATA buses (and why they are 16 bit) and also why muxes are being used to "select" the next state instead of decoders or combinational logic being used, so perhaps we can discuss this during the next class.

## Reflection

