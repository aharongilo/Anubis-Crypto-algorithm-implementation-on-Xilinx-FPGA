//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description:  omega.v represent the omega function of the algorithm.
//  			 the omega function extract the round key for every round, 
// 				 from the key we inserted to the algorithm.
// 				 we can insert the algorithm key with size of Nx4 (4<=N<=10)
// 				 matrix with GF(2^8) elements.
// 				 the function do matrix multiplication between the inserted key 
// 				 and a based on [N^4,5,N] MDS code generator matrix:
//				 1   1   1   ... 1
//				 1   2   2^2 ... 2^(N-1)
//				 1   6   6^2 ... 6^(N-1)
// 				 1   8   8^2 ... 8^(N-1)
//				 in our case, N=4, therefor, the matrix will be:
//		   	     1 1  1  1
//    			 1 2  4  8 
//    			 1 6 14 78
// 			     1 8 40 3a
// 				 the equation is:  extract key = V*key
// 				 extract key is a mtrix with size of 4x4.
// 				 the key vector is:
// 				 [MSB] 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 [LSB]
//
// 				 therefor, the key matrix is:
//  			 1  2  3  4
// 				 5  6  7  8
//			     9 10 11 12 
//				 13 14 15 16 
//
//				 in addition, the multiplying above GF(2^8) will be executed by block ROM module made using the 
// 				 VIVADO software of the Xilinx company.
// Uses modules: LUT in the ROM memory on the Xilinix Artix 7 FPGA chip
//------------------------------------------------------------------

module omega
(
	input clk,
	input [127:0] key,
	output [127:0] extract_key
);
reg [127:0] mult_result = 0;
// we will make wires to conect with the block rom modules. for example: mkey_4_4 mean multply by 4, the 4th element in the matrix column.
wire [7:0] mkey_2_1, mkey_2_2, mkey_2_3, mkey_2_4, mkey_4_1, mkey_4_2, mkey_4_3, mkey_4_4, mkey_8_1, mkey_8_2, mkey_8_3, mkey_8_4, mkey_6_1, mkey_6_2, mkey_6_3, mkey_6_4, mkey_14_1, mkey_14_2, mkey_14_3, mkey_14_4, mkey_78_1, mkey_78_2, mkey_78_3, mkey_78_4, mkey_8_5, mkey_8_6, mkey_8_7, mkey_8_8, mkey_64_1, mkey_64_2, mkey_64_3, mkey_64_4, mkey_3a_1, mkey_3a_2, mkey_3a_3, mkey_3a_4;
// multiplication second row in V matrix (the first row is all 1) 
//mult_rom C2R1M2 (clk,{3'b000,key[39:32]},mkey_2_1); //column 2 of key matrix, the element in the first row, multiply by 2
//mult_rom C2R2M2 (clk,{3'b000,key[47:40]},mkey_2_2);
//mult_rom C2R3M2 (clk,{3'b000,key[55:48]},mkey_2_3);
//mult_rom C2R4M2 (clk,{3'b000,key[63:56]},mkey_2_4);
mult_rom2 C2R1M2 (key[39:32],mkey_2_1);
mult_rom2 C2R2M2 (key[47:40],mkey_2_2);
mult_rom2 C2R3M2 (key[55:48],mkey_2_3);
mult_rom2 C2R4M2 (key[63:56],mkey_2_4);
/*mult_rom C3R1M4 (clk,{3'b001,key[71:64]},mkey_4_1);
mult_rom C3R2M4 (clk,{3'b001,key[79:72]},mkey_4_2);
mult_rom C3R3M4 (clk,{3'b001,key[87:80]},mkey_4_3);
mult_rom C3R4M4 (clk,{3'b001,key[95:88]},mkey_4_4);
*/
mult_rom4 C3R1M4 (key[71:64],mkey_4_1);
mult_rom4 C3R2M4 (key[79:72],mkey_4_2);
mult_rom4 C3R3M4 (key[87:80],mkey_4_3);
mult_rom4 C3R4M4 (key[95:88],mkey_4_4);

mult_rom C4R1M8 (clk,{3'b011,key[103:96]},mkey_8_1);
mult_rom C4R2M8 (clk,{3'b011,key[111:104]},mkey_8_2);
mult_rom C4R3M8 (clk,{3'b011,key[119:112]},mkey_8_3);
mult_rom C4R4M8 (clk,{3'b011,key[127:120]},mkey_8_4);

// multiplication third row in V matrix 
mult_rom C2R1M6 (clk,{3'b010,key[39:32]},mkey_6_1);
mult_rom C2R2M6 (clk,{3'b010,key[47:40]},mkey_6_2);
mult_rom C2R3M6 (clk,{3'b010,key[55:48]},mkey_6_3);
mult_rom C2R4M6 (clk,{3'b010,key[63:56]},mkey_6_4);

mult_rom C3R1M14 (clk,{3'b100,key[71:64]},mkey_14_1);
mult_rom C3R2M14 (clk,{3'b100,key[79:72]},mkey_14_2);
mult_rom C3R3M14 (clk,{3'b100,key[87:80]},mkey_14_3);
mult_rom C3R4M14 (clk,{3'b100,key[95:88]},mkey_14_4);

mult_rom C4R1M78 (clk,{3'b111,key[103:96]},mkey_78_1);
mult_rom C4R2M78 (clk,{3'b111,key[111:104]},mkey_78_2);
mult_rom C4R3M78 (clk,{3'b111,key[119:112]},mkey_78_3);
mult_rom C4R4M78 (clk,{3'b111,key[127:120]},mkey_78_4);

// multiplication fourth row in V matrix 
mult_rom C2R1M8 (clk,{3'b011,key[39:32]},mkey_8_5);
mult_rom C2R2M8 (clk,{3'b011,key[47:40]},mkey_8_6);
mult_rom C2R3M8 (clk,{3'b011,key[55:48]},mkey_8_7);
mult_rom C2R4M8 (clk,{3'b011,key[63:56]},mkey_8_8);

mult_rom C3R1M64 (clk,{3'b110,key[71:64]},mkey_64_1);
mult_rom C3R2M64 (clk,{3'b110,key[79:72]},mkey_64_2);
mult_rom C3R3M64 (clk,{3'b110,key[87:80]},mkey_64_3);
mult_rom C3R4M64 (clk,{3'b110,key[95:88]},mkey_64_4);

mult_rom C4R1M3a (clk,{3'b101,key[103:96]},mkey_3a_1);
mult_rom C4R2M3a (clk,{3'b101,key[111:104]},mkey_3a_2);
mult_rom C4R3M3a (clk,{3'b101,key[119:112]},mkey_3a_3);
mult_rom C4R4M3a (clk,{3'b101,key[127:120]},mkey_3a_4);

always@(mkey_2_1 or mkey_2_2 or mkey_2_3 or mkey_2_4 or mkey_4_1 or mkey_4_2 or mkey_4_3 or mkey_4_4 or mkey_8_1 or mkey_8_2 or mkey_8_3 or mkey_8_4 or mkey_6_1 or mkey_6_2 or mkey_6_3 or mkey_6_4 or mkey_14_1 or mkey_14_2 or mkey_14_3 or mkey_14_4 or mkey_78_1 or mkey_78_2 or mkey_78_3 or mkey_78_4 or mkey_8_5 or mkey_8_6 or mkey_8_7 or mkey_8_8 or mkey_64_1 or mkey_64_2 or mkey_64_3 or mkey_64_4 or mkey_3a_1 or mkey_3a_2 or mkey_3a_3 or mkey_3a_4)
begin
	
	mult_result[7:0]     = (key[7:0] ^ key[39:32] ^ key[71:64] ^ key[103:96]);
	mult_result[15:8]    = (key[15:8] ^ key[47:40] ^ key[79:72] ^ key[111:104]);
	mult_result[23:16]   = (key[23:16] ^ key[55:48] ^ key[87:80] ^ key[119:112]);
	mult_result[31:24]   = (key[31:24] ^ key[63:56] ^ key[95:88] ^ key[127:120]);
	
	mult_result[39:32]   = (key[7:0]^mkey_2_1^mkey_4_1^mkey_8_1);
	mult_result[47:40]   = (key[15:8]^mkey_2_2^mkey_4_2^mkey_8_2);
	mult_result[55:48]   = (key[23:16]^mkey_2_3^mkey_4_3^mkey_8_3);
	mult_result[63:56]   = (key[31:24]^mkey_2_4^mkey_4_4^mkey_8_4);
	
	mult_result[71:64]   = (key[7:0]^mkey_6_1^mkey_14_1^mkey_78_1);
	mult_result[79:72]   = (key[15:8]^mkey_6_2^mkey_14_2^mkey_78_2);
	mult_result[87:80]   = (key[23:16]^mkey_6_3^mkey_14_3^mkey_78_3);
	mult_result[95:88]   = (key[31:24]^mkey_6_4^mkey_14_4^mkey_78_4);
	
	mult_result[103:96]  = (key[7:0]^mkey_8_5^mkey_64_1^mkey_3a_1);
	mult_result[111:104] = (key[15:8]^mkey_8_6^mkey_64_2^mkey_3a_2);
	mult_result[119:112] = (key[23:16]^mkey_8_7^mkey_64_3^mkey_3a_3);
	mult_result[127:120] = (key[31:24]^mkey_8_8^mkey_64_4^mkey_3a_4);
	
end

assign extract_key = mult_result;

endmodule //omega