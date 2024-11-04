module part3(input[17:0] SW, output[17:0] LEDR);
	assign LEDR[1:0]=(~{2{SW[9]}}&~{2{SW[8]}}&SW[1:0])|(~{2{SW[9]}}&{2{SW[8]}}&SW[3:2])|({2{SW[9]}}&~{2{SW[8]}}&SW[5:4])|({2{SW[9]}}&{2{SW[8]}}&SW[7:6]);
endmodule
