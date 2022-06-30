//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description:  pi.v represent the pi function of the algorithm.
//				 this function do permutation on the code word, as define
//				 in the algorithm:
//				 for a given matrix:
//				 1  2  3  4
//				 5  6  7  8
//				 9  10 11 12
//				 13 14 15 16
//				 the permutation will be:
//				 1  14 11  8
//				 5   2 15 12
//				 9   6  3 16
//				 13 10  7  4
//
// 				 *Note*:
//				 our algorithm is been describe matematicaly as a matrix with size of 4x4,
//				 and every word is an element from the GF(2^8).
//				 however, in the code the matrix is represent as 128 bits word. 
//				 therefor, we need to convert the matrix to a word.
//				 for the given matrix:
//				 1  2  3  4
//				 5  6  7  8
//			 	 9  10 11 12
//				 13 14 15 16
//
//				 the vector form of the matrix: 
//				 (MSB:)16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1(:LSB)
// Uses modules: none
//------------------------------------------------------------------

module pi(
	input [127:0] matrix,
	output [127:0] P_matrix
);

assign P_matrix[127:120] = matrix[31:24];
assign P_matrix[119:112] = matrix[55:48];
assign P_matrix[111:104] = matrix[79:72];
assign P_matrix[103:96]  = matrix[103:96];
assign P_matrix[95:88]   = matrix[127:120];
assign P_matrix[87:80]   = matrix[23:16];
assign P_matrix[79:72]   = matrix[47:40];
assign P_matrix[71:64]   = matrix[71:64];
assign P_matrix[63:56]   = matrix[95:88];
assign P_matrix[55:48]   = matrix[119:112];
assign P_matrix[47:40]   = matrix[15:8];
assign P_matrix[39:32]   = matrix[39:32];
assign P_matrix[31:24]   = matrix[63:56]; 
assign P_matrix[23:16]   = matrix[87:80];
assign P_matrix[15:8]    = matrix[111:104];
assign P_matrix[7:0]     = matrix[7:0];


endmodule //pi