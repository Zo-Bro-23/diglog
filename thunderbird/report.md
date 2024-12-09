# ZBird (Thunderbird)
## Design Process
I started my design process by deciding how I wanted my Thunderbird to behave. I decided that the light pattern will start once an input of "1" is received, and will only stop once the pattern completes itself. This means that if the input switches to "0" in between, it will not stop until the entire flashing pattern has been completed. Furthermore, I decided to have a switch for the "direction" (0 for left and 1 for right), and another switch for the "input" (0 for off and 1 for on). This will prevent both sides from being turned on at the same time.

Next, I drew a state transition diagram for the Thunderbird lights. Choosing to turn it off only after the cycle was a good decision because it simplified my finite state machine. This meant that each state would proceed onto the next state regardless of the input, except if the lights are off at which point the next state will be decided based on the input. I also drew a state transition table and a state encoding table.

![IMG_1603](https://github.com/user-attachments/assets/7f097b83-860a-4581-bd18-bab450b9f336)
![IMG_1604](https://github.com/user-attachments/assets/ba178896-8e6e-4915-a377-2c59ff2a1bd8)

I decided to have a two-bit state encoding with four total states: LEDs off, first LED on, first and second LED on, and all LEDs on. This worked well, and so I drew K-maps for each of the state encoding bits, basing my values on my state encoding table.

![IMG_1605](https://github.com/user-attachments/assets/8d26a890-0680-4263-9749-76b9acfaf180)

I wrote boolean expressions for each of the state encoding bits, and I was ready to start coding Verilog.

## Coding
I started by importing code for D-flip-flops from the previous project because I tried getting the in-built DFF to work and I couldn't. Next, I created wires for the "current state" (s) and the "next state". I assigned two D-flip-flops to set the "next state" to be the "current state", and I assigned the "current state" to be a boolean expression of the "next state". The naming of the current state and next state made things a bit difficult for me to follow, so I tried imagining the circuit diagram in my head. We start with a current state, which is a conditional logic combination of the flip-flops' previous output, which is essentially the same as its next output which is the "next state". This combination, or "current state", feeds in as an input to the flip-flops. Thinking about the code in this way made sense, and I could verify that my logic was correct.

I assigned the LED outputs by thinking about them in terms of conditional logic. I did not draw a truth table because it was very simple, but a state of 01, 10, or 11 would turn the first LED on, so this should be `s[0] | s[1]`. Similarly, the second LED is 10 or 11, which is the same as `s[1]`. Finally, the third LED will only be on in 11, which is `s[0] & s[1]`.

Thus, I was done with my first prototype.

```verilog
module light(input clk, input in, output a, b, c);
	wire sn[1:0];
	wire s[1:0];
	DFFl flip0(s[0], clk, sn[0]);
	DFFl flip1(s[1], clk, sn[1]);
	assign s[0] = ~sn[0] & (in | sn[1]);
	assign s[1] = (sn[1] & ~sn[0]) | (~sn[1] & sn[0] & ~in);
	assign a = s[0] & s[1];
	assign b = s[1];
	assign c = s[0] | s[1];
endmodule

module DFFl(input d, input clk, output q);
	wire CLK1;
	wire CLK2;
	wire Q1;
	wire Q2;
	assign CLK2 = clk;
	assign CLK1 = ~clk;
	DLat D1(d, CLK1, Q1);
	DLat D2(Q1, CLK2, Q2);
	assign q = Q2;
endmodule

module DLat(input d, input e, output q);
	assign q = ~((~d & e) | nq);
	assign nq = ~((d & e) | q);
endmodule
```

## Debugging
Initially, my code did not work on my FPGA, and behaved very weirdly. I tried a waveform simulation, and realized that the entire output was greyed out because I did not have a reset for my flip-flops. I thought I could get away without having a reset, because the last project worked, but I realized that the last project worked because the flip-flops were essentially getting reset when they got an input of 0. Thus I read up the section in the textbook on resettable flip-flops, and learnt that you could either reset it at the input (immediately reset) or inside the flip-flop (resets on the next clock tick). It sounded easier to work at it on the input, so I did a `D & ~reset` instead of `D` for the inputs of my flip-flops. My FPGA still behaved weirdly, and although I do not remember how my waveform worked exactly, I do not think it worked as expected.

I revisited my boolean expressions and realized that one of them was incorrect due to a mistake when reading from the truth table into the K-maps. I fixed that error, and my waveform worked.

```verilog
module light(input clk, input reset, input in, output a, b, c);
	wire sn[1:0];
	wire s[1:0];
	DFFl flip0((s[0] & ~reset), clk, sn[0]);
	DFFl flip1((s[1] & ~reset), clk, sn[1]);
	assign s[0] = ~sn[0] & (in | sn[1]);
	assign s[1] = (sn[1] & ~sn[0]) | (~sn[1] & sn[0]);
	assign a = s[0] & s[1];
	assign b = s[1];
	assign c = s[0] | s[1];
endmodule
```

![image](https://github.com/user-attachments/assets/c16725d1-19fc-44c8-bb0f-e25300cbd25c)

[Video](https://drive.google.com/file/d/1Ag_py-D7EoxWpAZVfo8DWmFsyNGwUbq3/view?usp=drive_link)

## Extension
Since the right and left are the same with the order of the LEDs reversed, I made my light machine into a module and repeated it twice for both sides. I cleaned up my code and connected it to the right FPGA pins, and I was ready to test. My waveform worked as expected, and so I tried it out on the FPGA. It was working well for the most part, but I noticed that the first LED was turning on as soon as the input was turned on, and wouldn't wait for the clock tick. Mr. Bakker suggested doing further testing on the waveform, and I realized that the first LED would also not turn off when the flip-flops were reset. I went back to the code and read through the logic in my mind, and I realized the mistake. The first LED was `s[0] | s[1]`, and that was the only one being turned on, so `s[0]` must be the problem. `s[0]=~sn[0] & (in | sn[1])`, and when the flip-flops were reset `sn[0]=sn[1]=0`, so if `in=1`, then `s[0]=1`. This made sense, but this was not how I expected it to work. I then realized that I was supposed to base the LED outputs on `sn` and not `s`, because the LEDs were typically connected to the outputs of the flip-flops, not the inputs. I changed the LED assignments from `s` to `sn`, and here is the resulting code.

```verilog
module zbird(input [3:0] KEY, input [17:0] SW, output [17:0] LEDR);
	wire direction;
	assign direction = SW[0];
	
	light left(
		.clk(~KEY[2]), 
		.in(~direction & SW[17]),
		.reset(~KEY[3]), 
		.a(LEDR[11]), 
		.b(LEDR[10]), 
		.c(LEDR[9])
		);
	
	light right(
		.clk(~KEY[2]), 
		.in(direction & SW[17]), 
		.reset(~KEY[3]), 
		.a(LEDR[0]), 
		.b(LEDR[1]), 
		.c(LEDR[2]));
endmodule

module light(input clk, input reset, input in, output a, b, c);
	wire sn[1:0];
	wire s[1:0];
	DFFl flip0((s[0] & ~reset), clk, sn[0]);
	DFFl flip1((s[1] & ~reset), clk, sn[1]);
	assign s[0] = ~sn[0] & (in | sn[1]);
	assign s[1] = (sn[1] & ~sn[0]) | (~sn[1] & sn[0]);
	assign a = sn[0] & sn[1];
	assign b = sn[1];
	assign c = sn[0] | sn[1];
endmodule
```

![image](https://github.com/user-attachments/assets/c065d2df-bc1c-45b6-8828-8502afa10293)

## Debugging 2.0
The code now worked perfectly on the waveform. On the FPGA, however, it was terribly consistently inconsistent. What I mean is, it followed a pattern of `111`, `000`, `111`, `000`, `111`, `011`, `001`, `000`, `111`, etc, or something similar. It followed a similar pattern each time, but there were variations in the number of iterations, and it behaved nothing like the waveform. After talking to Kevin, I realized that he was facing a similar problem. He seemed to think that it was an issue with the internal wiring and timing of the FPGA. I spent a significant amount of time with Edie, and she had similar results with her code. Nikol had virtually the same code as me, except for her flip-flops, which she reset at the SR-level, and hers works, although I struggle to see how the resetting of the flip-flop could affect it. I also find it difficult to work with since the waveform works as expected.

[Video](https://drive.google.com/file/d/1K6iHvUMId_EkFjfc0gZ__hud8cFqbwsC/view?usp=drive_link)

## Musings
I have been thinking about the difference between assigning the LEDs based on `s` and `sn`, and I don't think there is any difference except for the observed behavior of the first LED toggling immediately based on the input signal. Everything else should work as expected, since `s` is merely "one cycle" ahead of `sn` with respect to the input. After one clock tick, `sn` becomes `s`, and so having the LEDs based on `s` will mean that they update one tick sooner than `sn`, which explains the observed first LED's seeming disregard for the clock tick. Thus, although I spent a long time trying to figure out why my waveform and FPGA were inconsistent with each other for the modified `sn` design, I was unable to debug it, and so I decided to finalize on the `s` design. It works well for a thunderbird light signal, except for the fact that the first LED seems to irk me with its inconsistency with the rest of the lights :(

https://github.com/Zo-Bro-23/diglog/blob/f2c953f706b7288a78234bbc675e1ca78345b063/thunderbird/zbird.v#L1-L50

## Debugging 3.0
After my conversation with Mr. Bakker, I tried rewriting the code with a double flip-flop that uses two clock signals to prevent switch bouncing. (I also renamed variables and added comments)

https://github.com/Zo-Bro-23/diglog/blob/fda3fd09c96a3a761be4820922697fb9630bcfa5/thunderbird/zbird.v#L1-L64

As surprising as it was, my code worked! This means that switch bouncing was the problem, but I still didn't understand why the switches didn't bounce when the LEDs were connected to the Next State instead of the Current State. My guess is that it has something to do with the way the LEDs are positioned in the circuit and the timing of the components in the FPGA.

![image](https://github.com/user-attachments/assets/cc1dd6ca-200f-42ff-9c12-36445c345942)

[Video](https://drive.google.com/file/d/16zfFXPwM0HfBT82VAHqFDWpW2nVPaQLY/view?usp=drive_link)

## Conclusion
I had a conversation with Griffin about the issues with my circuit, and I have a vague understanding of what is happening. We think that since the components take time to change voltage, a single clock high is letting multiple states pass through the flip-flop before it becomes low. This will not happen when using two clock signals, hence why the final circuit worked. We suspect that connecting the LEDs to the Next State instead of the Current State adds a delay before the Next State is passed on to the flip flop, hence why that circuit also works. I am still hesitant to believe that it is an issue with switch bouncing since the circuit works when the LEDs are connected to the Next State. If it was an issue with switch or key bouncing, that circuit should also bounce. Moreover, the bouncing should be inconsistent. The issue seen with the circuit is more or less consistent across FPGAs, with `111` and `000` alternating, along with the occasional `011` or `001`. Griffin claims to have done some testing that aligns with this hypothesis. If I am able to find some time, I will also do some testing as a sort of "extension" for the project.
