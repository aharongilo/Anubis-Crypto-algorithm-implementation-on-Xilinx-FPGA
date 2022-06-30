`timescale 1ns / 1ps
//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description: transmit_top.v is the top module of UART transmitter
// Uses modules: transmit_debouncing.v, transmitter.v
//------------------------------------------------------------------

module transmit_top(
	input  wire		   clk,			// onboard 100 Mhz clock
	input  wire		   reset_b, 		// onboard reset
	output reg 	   	   TxD, 			// data transmitted through communication protocol
	input  wire		   r_sync,			// device is requesting to sync with basys3
	input  wire		   r_acknowledge,	// device acknowledgement for Basys3 accepting synchronization
	output reg 		   basys3_sync,		// Basys3 request to Synchronize with remote device- basys3=sender
	output reg 		   basys3_acknowledge, // Basys3 acknowledgement of request by remote device
	input wire	       enable,			// enables module
	input wire [127:0] data_out,		    // 128 bits of data to send in protocol
	input wire		   encrypt,			// encryption mode for the sent data '0'=plaintext '1'=ciphertext
	output wire 	   ready			// all data have been sent flag
						
);
reg [8:0]   bit_cntr;
reg 	    flag ;

assign ready = flag; // '1'= 129 bits have been sent through TxD
 					 // '0'= still processing

always @ (posedge clk)
	begin
		if (reset_b)
			begin
			TxD		 <= 1'b0;
			bit_cntr <= 9'b0;
			basys3_sync	 <= 1'b0;
			basys3_acknowledge <= 1'b0;
			flag = 1'b0;
			end
		else //reset_b = b'0
			begin
				if(enable && ~r_acknowledge) //IDLE-communication with other device starts
					begin
						bit_cntr <=0'b0; //RxD defines encryption mode
						TxD <= encrypt;
						basys3_sync = 1'b1;
						basys3_acknowledge = 1'b0;//enables the case statements
						flag = 1'b0;
						
					end
				else
					if(enable && basys3_sync && r_acknowledge)//data is being sent through RxD
						begin
							if (bit_cntr<9'd128)
								begin
								bit_cntr<= bit_cntr+1;
								basys3_sync <= 1'b1;
								basys3_acknowledge <= 1'b1;
								flag <= 1'b0;
								end
							else
								flag<= 1'b1; // raise a flag for the end of the transmitted data
						end
			end
	end
	always @ (posedge clk)
	begin
			if (enable && basys3_acknowledge && r_acknowledge &&~r_sync)
				begin
					case (bit_cntr)
							0:	  TxD		<= encrypt; // once r_sync is on, basys3 recieve encryption mode
							1:	  TxD   	<= data_out[127];
							2:    TxD  		<= data_out[126];
							3:    TxD  		<= data_out[125];
							4:    TxD  		<= data_out[124];
							5:    TxD  		<= data_out[123];
							6:    TxD  		<= data_out[122];
							7:    TxD 		<= data_out[121];
							8:    TxD		<= data_out[120];
							9:	  TxD   	<= data_out[119];
							10:   TxD  		<= data_out[118];
							11:   TxD  		<= data_out[117];
							12:   TxD  		<= data_out[116];
							13:   TxD  		<= data_out[115];
							14:   TxD  		<= data_out[114];
							15:   TxD 		<= data_out[113];
							16:   TxD		<= data_out[112];
							17:	  TxD   	<= data_out[111];
							18:	  TxD   	<= data_out[110];
							19:	  TxD   	<= data_out[109];
							20:	  TxD   	<= data_out[108];
							21:	  TxD   	<= data_out[107];
							22:	  TxD   	<= data_out[106];
							23:	  TxD   	<= data_out[105];
							24:	  TxD   	<= data_out[104];
							25:	  TxD 	 	<= data_out[103];
							26:	  TxD   	<= data_out[102];
							27:	  TxD   	<= data_out[101];
							28:	  TxD   	<= data_out[100];
							29:	  TxD   	<= data_out[99];
							30:	  TxD   	<= data_out[98];
							31:	  TxD   	<= data_out[97];
							32:	  TxD   	<= data_out[96];
							33:	  TxD   	<= data_out[95];   
							34:   TxD       <= data_out[94];   
							35:   TxD       <= data_out[93];   
							36:   TxD       <= data_out[92];   
							37:   TxD       <= data_out[91];   
							38:   TxD       <= data_out[90];   
							39:   TxD       <= data_out[89];   
							40:   TxD       <= data_out[88];   
							41:   TxD       <= data_out[87];   
							42:   TxD       <= data_out[86];   
							43:   TxD       <= data_out[85];   
							44:   TxD       <= data_out[84];   
							45:   TxD       <= data_out[83];   
							46:   TxD       <= data_out[82];   
							47:   TxD       <= data_out[81];   
							48:   TxD       <= data_out[80];   
							49:   TxD       <= data_out[79];   
							50:   TxD       <= data_out[78];   
							51:   TxD       <= data_out[77];   
							52:   TxD       <= data_out[76];   
							53:   TxD       <= data_out[75];   
							54:   TxD       <= data_out[74];   
							55:   TxD       <= data_out[73];   
							56:   TxD       <= data_out[72];   
							57:   TxD       <= data_out[71];   
							58:   TxD       <= data_out[70];   
							59:   TxD       <= data_out[69];   
							60:   TxD       <= data_out[68];   
							61:   TxD       <= data_out[67];   
							62:   TxD       <= data_out[66];   
							63:   TxD       <= data_out[65];   
							64:   TxD       <= data_out[64];   
							65:	  TxD       <= data_out[63];   
							67:   TxD       <= data_out[62];   
							66:   TxD       <= data_out[61];   
							68:   TxD       <= data_out[60];   
							69:   TxD       <= data_out[59];   
							70:   TxD       <= data_out[58];   
							71:   TxD       <= data_out[57];   
							72:   TxD       <= data_out[56];   
							73:   TxD       <= data_out[55];   
							74:   TxD       <= data_out[54];   
							75:   TxD       <= data_out[53];   
							76:   TxD       <= data_out[52];   
							77:   TxD       <= data_out[51];   
							78:   TxD       <= data_out[50];   
							79:   TxD       <= data_out[49];   
							80:   TxD       <= data_out[48];   
							81:   TxD       <= data_out[47];   
							82:   TxD       <= data_out[46];   
							83:   TxD       <= data_out[45];   
							84:   TxD       <= data_out[44];   
							85:   TxD       <= data_out[43];   
							86:   TxD       <= data_out[42];   
							87:   TxD       <= data_out[41];   
							88:   TxD       <= data_out[40];   
							89:   TxD       <= data_out[39];   
							90:   TxD       <= data_out[38];   
							91:   TxD       <= data_out[37];   
							92:   TxD       <= data_out[36];   
							93:   TxD       <= data_out[35];   
							94:   TxD       <= data_out[34];   
							95:   TxD       <= data_out[33];   
							96:   TxD       <= data_out[32];   
							97:	  TxD       <= data_out[31];		
							98:   TxD       <= data_out[30];   
							99:   TxD       <= data_out[29];   
							100:  TxD       <= data_out[28];   
							101:  TxD       <= data_out[27];   
							102:  TxD       <= data_out[26];   
							103:  TxD       <= data_out[25];   
							104:  TxD       <= data_out[24];   
							105:  TxD       <= data_out[23];   
							106:  TxD       <= data_out[22];   
							107:  TxD       <= data_out[21];   
							108:  TxD       <= data_out[20];   
							109:  TxD       <= data_out[19];   
							110:  TxD       <= data_out[18];   
							111:  TxD       <= data_out[17];   
							112:  TxD       <= data_out[16];   
							113:  TxD       <= data_out[15];   
							114:  TxD       <= data_out[14];   
							115:  TxD       <= data_out[13];   
							116:  TxD       <= data_out[12];   
							117:  TxD       <= data_out[11];   
							118:  TxD       <= data_out[10];   
							119:  TxD        <= data_out[9];   
							120:  TxD        <= data_out[8];   
							121:  TxD        <= data_out[7];   
							122:  TxD        <= data_out[6];   
							123:  TxD        <= data_out[5];   
							124:  TxD        <= data_out[4];   
							125:  TxD        <= data_out[3];   
							126:  TxD        <= data_out[2];   
							127:  TxD        <= data_out[1];   
							128:  TxD        <= data_out[0];
							default: TxD<= 1'b0;
					endcase
				end
			else
				if (enable && basys3_sync && r_acknowledge &&r_sync)
					TxD<= 1'b0;
	end
endmodule //transmit_top
