//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description:  this module represent the theta function in the algorithm.
//				 the theta function multiply the data matrix 
//				    a1  a2  a3  a4
//				    a5  a6  a7  a8
//				    a9  a10 a11 a12
//				    a13 a14 a15 a16
//				 with a based on [8,4,5] MDS linear code generator matrix(H):
//				    1  2  4  6
//				    2  1  6  4
//				    4  6  1  2
//				    6  4  2  1
//				 and with that, it deffused the inputted data.
//				 the equation is:  c = a*H, where c represent the diffused data and a represent the input data.
//				 since every element in the matrix is from GF(2^8), and we multiply him, we need
//				 to do modulo with the primitive polynom the algorithm is using - "11d".
//				 when multiply, the fist line of the result matrix is:
//				 c1 = a1 + 2*(a2 + a4) + 4*(a3 + a4)
//				 c2 = a2 + 2*(a1 + a3) + 4*(a3 + a4)
//				 c3 = a3 + 2*(a2 + a4) + 4*(a1 + a2)
//				 c4 = a4 + 2*(a1 + a3) + 4*(a1 + a2)
//				 the rest of the lines are in the same form, just with the elements of the compatible line
//				 in the input matrix.
//				 in addition, the multiplying above GF(2^8) will be executed by block ROM module made using the 
//				 VIVADO software of the Xilinx company.
// Uses modules: LUT in the ROM memory on the Xilinix Artix 7 FPGA Chip
//------------------------------------------------------------------

module theta(
	input clk,
	input [127:0] data_in,
	output [127:0] deffused_data
);

wire [7:0] temp1 , temp2, temp3, temp4, temp5, temp6, temp7, temp8, temp9, temp10, temp11, temp12, temp13, temp14, temp15, temp16;
reg [127:0] result = 0;

//LSB: first line in the matrix
mult_rom2 M1(data_in[15:8]^data_in[31:24],temp1);  
mult_rom2 M2(data_in[7:0]^data_in[23:16],temp2);
mult_rom4 M3(data_in[23:16]^data_in[31:24],temp3);
mult_rom4 M4(data_in[7:0]^data_in[15:8],temp4);

mult_rom2 M5((data_in[47:40]^data_in[63:56]),temp5);
mult_rom2 M6((data_in[39:32]^data_in[55:48]),temp6);
mult_rom4 M7((data_in[55:48]^data_in[63:56]),temp7);
mult_rom4 M8((data_in[39:32]^data_in[47:40]),temp8);

mult_rom2 M9((data_in[79:72]^data_in[95:88]),temp9);
mult_rom2 M10((data_in[71:64]^data_in[87:80]),temp10);
mult_rom4 M11((data_in[87:80]^data_in[95:88]),temp11);
mult_rom4 M12((data_in[71:64]^data_in[79:72]),temp12);

mult_rom2 M13((data_in[111:104]^data_in[127:120]),temp13);
mult_rom2 M14((data_in[103:96]^data_in[119:112]),temp14);
mult_rom4 M15((data_in[119:112]^data_in[127:120]),temp15);
mult_rom4 M16((data_in[103:96]^data_in[111:104]),temp16);
/*mult_rom M1(clk,{3'b000,data_in[15:8]^data_in[31:24]},temp1);  
mult_rom M2(clk,{3'b000,data_in[7:0]^data_in[23:16]},temp2);
mult_rom M3(clk,{3'b001,data_in[23:16]^data_in[31:24]},temp3);
mult_rom M4(clk,{3'b001,data_in[7:0]^data_in[15:8]},temp4);

mult_rom M5(clk,{3'b000,(data_in[47:40]^data_in[63:56])},temp5);
mult_rom M6(clk,{3'b000,(data_in[39:32]^data_in[55:48])},temp6);
mult_rom M7(clk,{3'b001,(data_in[55:48]^data_in[63:56])},temp7);
mult_rom M8(clk,{3'b001,(data_in[39:32]^data_in[47:40])},temp8);

mult_rom M9(clk,{3'b000,(data_in[79:72]^data_in[95:88])},temp9);
mult_rom M10(clk,{3'b000,(data_in[71:64]^data_in[87:80])},temp10);
mult_rom M11(clk,{3'b001,(data_in[87:80]^data_in[95:88])},temp11);
mult_rom M12(clk,{3'b001,(data_in[71:64]^data_in[79:72])},temp12);

mult_rom M13(clk,{3'b000,(data_in[111:104]^data_in[127:120])},temp13);
mult_rom M14(clk,{3'b000,(data_in[103:96]^data_in[119:112])},temp14);
mult_rom M15(clk,{3'b001,(data_in[119:112]^data_in[127:120])},temp15);
mult_rom M16(clk,{3'b001,(data_in[103:96]^data_in[111:104])},temp16);
*/
always @(temp1 or temp2 or temp3 or temp4 or temp5 or temp6 or temp7 or temp8 or temp9 or temp10 or temp11 or temp12 or temp13 or temp14 or temp15 or temp16)
begin
	result[127:120] = data_in[127:120]^temp14^temp16;   
	result[119:112] = data_in[119:112]^temp13^temp16;
	result[111:104] = data_in[111:104]^temp14^temp15;
	result[103:96]  = data_in[103:96]^temp13^temp15;
	
	result[95:88] = data_in[95:88]^temp10^temp12;
	result[87:80] = data_in[87:80]^temp9^temp12;
	result[79:72] = data_in[79:72]^temp10^temp11;
	result[71:64] = data_in[71:64]^temp9^temp11;
	
	result[63:56] = data_in[63:56]^temp6^temp8;
	result[55:48] = data_in[55:48]^temp5^temp8;
	result[47:40] = data_in[47:40]^temp6^temp7;
	result[39:32] = data_in[39:32]^temp5^temp7;
	
	result[31:24] = data_in[31:24]^temp2^temp4;
	result[23:16] = data_in[23:16]^temp1^temp4;
	result[15:8] = data_in[15:8]^temp2^temp3;
	result[7:0]  = data_in[7:0]^temp1^temp3;
end

assign deffused_data = result;

endmodule  //theta
