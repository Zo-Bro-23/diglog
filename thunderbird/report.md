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

## Debugging
