//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description:  sigma module represent the sigma function in teh algorithm
//				 this function do bitwise xor between 2 inputs.
// used modules: none
//------------------------------------------------------------------

module sigma
(
	input [127:0] in1,
	input [127:0] in2,
	output [127:0] out
);

assign out = in1^in2;

endmodule