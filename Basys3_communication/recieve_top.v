//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description: recieve_top.v implements PMOD reciever communication
// Uses modules:
//------------------------------------------------------------------
module recieve_top(
	input  wire		   clk,			// onboard 100 Mhz clock
	input  wire		   reset_b, 		// onboard reset
	input  wire 	   RxD, 			// data recieved through communication protocol
	input  wire		   r_sync,			// device is requesting to sync with basys3
	input  wire		   r_acknowledge,	// device acknowledgement for Basys3 accepting synchronization
	input  wire 	   basys3_sync,		// Basys3 request to Synchronize with remote device- basys3=sender
	input  wire 		   basys3_acknowledge, // Basys3 acknowledgement of request by remote device
	input  wire	       enable,			//enables module
	output reg [127:0] data_in,			// 128 bits of recieved data
	output reg [127:0] key_in,			// 128 bits of recieved key
	output reg		   encrypt,	 		// encryption mode for the recieved data
	output wire 	   ready			// all data have been received flag
);
reg [8:0]   bit_cntr;
reg 	    flag ;

assign ready = flag; // '1'= 257 bits have been received through RxD
 					 // '0'= still processing

always @ (posedge clk)
begin
	if (reset_b)
	begin
	data_in		 <= 128'b0;
	key_in		 <= 128'b0;
	bit_cntr 	 <= 9'b0;
	flag <= 1'b0;
	end
	else //reset_b = b'0
	begin
		if(enable && r_sync && ~r_acknowledge) //communication with other device starts
		begin
			bit_cntr <=0'b0; //RxD defines encryption mode
			flag <= 1'b0;
		end
		else
			if(enable && r_sync && r_acknowledge)//data is being sent through RxD
			begin
				if (bit_cntr<9'd256)
				begin
					bit_cntr<= bit_cntr+1;


					flag <= 1'b0;
				end
				else
				begin
					flag <= 1; // raise a flag for the end of the received data
				end
			end
	end
end		
always @ (posedge clk)
	begin
			if (basys3_acknowledge && enable)
				begin
					case (bit_cntr)
							0:	  encrypt			<= RxD; // once r_sync is on, basys3 recieve encryption mode
							1:	  data_in[127]   	<= RxD;
							2:    data_in[126]  	<= RxD;
							3:    data_in[125]  	<= RxD;
							4:    data_in[124]  	<= RxD;
							5:    data_in[123]  	<= RxD;
							6:    data_in[122]  	<= RxD;
							7:    data_in[121] 		<= RxD;
							8:    data_in[120]		<= RxD;
							9:	  data_in[119]   	<= RxD;
							10:   data_in[118]  	<= RxD;
							11:   data_in[117]  	<= RxD;
							12:   data_in[116]  	<= RxD;
							13:   data_in[115]  	<= RxD;
							14:   data_in[114]  	<= RxD;
							15:   data_in[113] 		<= RxD;
							16:   data_in[112]		<= RxD;
							17:	  data_in[111]   	<= RxD;
							18:	  data_in[110]   	<= RxD;
							19:	  data_in[109]   	<= RxD;
							20:	  data_in[108]   	<= RxD;
							21:	  data_in[107]   	<= RxD;
							22:	  data_in[106]   	<= RxD;
							23:	  data_in[105]   	<= RxD;
							24:	  data_in[104]   	<= RxD;
							25:	  data_in[103]   	<= RxD;
							26:	  data_in[102]   	<= RxD;
							27:	  data_in[101]   	<= RxD;
							28:	  data_in[100]   	<= RxD;
							29:	  data_in[99]   	<= RxD;
							30:	  data_in[98]   	<= RxD;
							31:	  data_in[97]   	<= RxD;
							32:	  data_in[96]   	<= RxD;
							33:	  data_in[95]   	<= RxD;   
							34:   data_in[94]       <= RxD;   
							35:   data_in[93]       <= RxD;   
							36:   data_in[92]       <= RxD;   
							37:   data_in[91]       <= RxD;   
							38:   data_in[90]       <= RxD;   
							39:   data_in[89]       <= RxD;   
							40:   data_in[88]       <= RxD;   
							41:   data_in[87]       <= RxD;   
							42:   data_in[86]       <= RxD;   
							43:   data_in[85]       <= RxD;   
							44:   data_in[84]       <= RxD;   
							45:   data_in[83]       <= RxD;   
							46:   data_in[82]       <= RxD;   
							47:   data_in[81]       <= RxD;   
							48:   data_in[80]       <= RxD;   
							49:   data_in[79]       <= RxD;   
							50:   data_in[78]       <= RxD;   
							51:   data_in[77]       <= RxD;   
							52:   data_in[76]       <= RxD;   
							53:   data_in[75]       <= RxD;   
							54:   data_in[74]       <= RxD;   
							55:   data_in[73]       <= RxD;   
							56:   data_in[72]       <= RxD;   
							57:   data_in[71]       <= RxD;   
							58:   data_in[70]       <= RxD;   
							59:   data_in[69]       <= RxD;   
							60:   data_in[68]       <= RxD;   
							61:   data_in[67]       <= RxD;   
							62:   data_in[66]       <= RxD;   
							63:   data_in[65]       <= RxD;   
							64:   data_in[64]       <= RxD;   
							65:	  data_in[63]       <= RxD;   
							67:   data_in[61]       <= RxD;   
							66:   data_in[62]       <= RxD;   
							68:   data_in[60]       <= RxD;   
							69:   data_in[59]       <= RxD;   
							70:   data_in[58]       <= RxD;   
							71:   data_in[57]       <= RxD;   
							72:   data_in[56]       <= RxD;   
							73:   data_in[55]       <= RxD;   
							74:   data_in[54]       <= RxD;   
							75:   data_in[53]       <= RxD;   
							76:   data_in[52]       <= RxD;   
							77:   data_in[51]       <= RxD;   
							78:   data_in[50]       <= RxD;   
							79:   data_in[49]       <= RxD;   
							80:   data_in[48]       <= RxD;   
							81:   data_in[47]       <= RxD;   
							82:   data_in[46]       <= RxD;   
							83:   data_in[45]       <= RxD;   
							84:   data_in[44]       <= RxD;   
							85:   data_in[43]       <= RxD;   
							86:   data_in[42]       <= RxD;   
							87:   data_in[41]       <= RxD;   
							88:   data_in[40]       <= RxD;   
							89:   data_in[39]       <= RxD;   
							90:   data_in[38]       <= RxD;   
							91:   data_in[37]       <= RxD;   
							92:   data_in[36]       <= RxD;   
							93:   data_in[35]       <= RxD;   
							94:   data_in[34]       <= RxD;   
							95:   data_in[33]       <= RxD;   
							96:   data_in[32]       <= RxD;   
							97:	  data_in[31]       <= RxD;		
							98:   data_in[30]       <= RxD;   
							99:   data_in[29]       <= RxD;   
							100:  data_in[28]       <= RxD;   
							101:  data_in[27]       <= RxD;   
							102:  data_in[26]       <= RxD;   
							103:  data_in[25]       <= RxD;   
							104:  data_in[24]       <= RxD;   
							105:  data_in[23]       <= RxD;   
							106:  data_in[22]       <= RxD;   
							107:  data_in[21]       <= RxD;   
							108:  data_in[20]       <= RxD;   
							109:  data_in[19]       <= RxD;   
							110:  data_in[18]       <= RxD;   
							111:  data_in[17]       <= RxD;   
							112:  data_in[16]       <= RxD;   
							113:  data_in[15]       <= RxD;   
							114:  data_in[14]       <= RxD;   
							115:  data_in[13]       <= RxD;   
							116:  data_in[12]       <= RxD;   
							117:  data_in[11]       <= RxD;   
							118:  data_in[10]       <= RxD;   
							119:  data_in[9]        <= RxD;   
							120:  data_in[8]        <= RxD;   
							121:  data_in[7]        <= RxD;   
							122:  data_in[6]        <= RxD;   
							123:  data_in[5]        <= RxD;   
							124:  data_in[4]        <= RxD;   
							125:  data_in[3]        <= RxD;   
							126:  data_in[2]        <= RxD;   
							127:  data_in[1]        <= RxD;   
							128:  data_in[0]        <= RxD;
							129:  key_in[127]   	<= RxD;
							130:  key_in[126]  		<= RxD;
							131:  key_in[125]  		<= RxD;
							132:  key_in[124]  		<= RxD;
							133:  key_in[123]  		<= RxD;
							134:  key_in[122]  		<= RxD;
							135:  key_in[121] 		<= RxD;
							136:  key_in[120]		<= RxD;
							137:  key_in[119]   	<= RxD;
							138:  key_in[118]  		<= RxD;
							139:  key_in[117]  		<= RxD;
							140:  key_in[116]  		<= RxD;
							141:  key_in[115]  		<= RxD;
							142:  key_in[114]  		<= RxD;
							143:  key_in[113] 		<= RxD;
							144:  key_in[112]		<= RxD;
							145:  key_in[111]   	<= RxD;
							146:  key_in[110]   	<= RxD;
							147:  key_in[109]   	<= RxD;
							148:  key_in[108]   	<= RxD;
							149:  key_in[107]   	<= RxD;
							150:  key_in[106]   	<= RxD;
							151:  key_in[105]   	<= RxD;
							152:  key_in[104]   	<= RxD;
							153:  key_in[103]   	<= RxD;
							154:  key_in[102]   	<= RxD;
							155:  key_in[101]   	<= RxD;
							156:  key_in[100]   	<= RxD;
							157:  key_in[99]   		<= RxD;
							158:  key_in[98]     	<= RxD;
							159:  key_in[97]   	    <= RxD;
							160:  key_in[96]     	<= RxD;
							161:  key_in[95]     	<= RxD;
							162:  key_in[94]   	    <= RxD;
							163:  key_in[93]        <= RxD;
							164:  key_in[92]        <= RxD;
							165:  key_in[91]        <= RxD;
							166:  key_in[90]        <= RxD;
							167:  key_in[89]        <= RxD;
							168:  key_in[88]        <= RxD;
							169:  key_in[87]        <= RxD;
							170:  key_in[86]        <= RxD;
							171:  key_in[85]        <= RxD;
							172:  key_in[84]        <= RxD;
							173:  key_in[83]        <= RxD;
							174:  key_in[82]        <= RxD;
							175:  key_in[81]        <= RxD;
							176:  key_in[80]        <= RxD;
							177:  key_in[79]        <= RxD;
							178:  key_in[78]        <= RxD;
							179:  key_in[77]        <= RxD;
							180:  key_in[76]        <= RxD;
							181:  key_in[75]        <= RxD;
							182:  key_in[74]        <= RxD;
							183:  key_in[73]        <= RxD;
							184:  key_in[72]        <= RxD;
							185:  key_in[71]        <= RxD;
							186:  key_in[70]        <= RxD;
							187:  key_in[69]        <= RxD;
							188:  key_in[68]        <= RxD;
							189:  key_in[67]        <= RxD;
							190:  key_in[66]        <= RxD;
							191:  key_in[65]        <= RxD;
							192:  key_in[64]        <= RxD;
							193:  key_in[63]        <= RxD;
							194:  key_in[61]        <= RxD;
							195:  key_in[62]        <= RxD;
							196:  key_in[60]        <= RxD;
							197:  key_in[59]        <= RxD;
							198:  key_in[58]        <= RxD;
							199:  key_in[57]        <= RxD;
							200:  key_in[56]        <= RxD;
							201:  key_in[55]        <= RxD;
							202:  key_in[54]        <= RxD;
							203:  key_in[53]        <= RxD;
							204:  key_in[52]        <= RxD;
							205:  key_in[51]        <= RxD;
							206:  key_in[50]        <= RxD;
							207:  key_in[49]        <= RxD;
							208:  key_in[48]        <= RxD;
							209:  key_in[47]        <= RxD;
							210:  key_in[46]        <= RxD;
							211:  key_in[45]        <= RxD;
							212:  key_in[44]        <= RxD;
							213:  key_in[43]        <= RxD;
							214:  key_in[42]        <= RxD;
							215:  key_in[41]        <= RxD;
							216:  key_in[40]        <= RxD;
							217:  key_in[39]        <= RxD;
							218:  key_in[38]        <= RxD;
							219:  key_in[37]        <= RxD;
							220:  key_in[36]        <= RxD;
							221:  key_in[35]        <= RxD;
							222:  key_in[34]        <= RxD;
							223:  key_in[33]        <= RxD;
							224:  key_in[32]        <= RxD;
							225:  key_in[31]   	    <= RxD;
							226:  key_in[30]        <= RxD;
							227:  key_in[29]        <= RxD;
							228:  key_in[28]        <= RxD;
							229:  key_in[27]        <= RxD;
							230:  key_in[26]        <= RxD;
							231:  key_in[25]        <= RxD;
							232:  key_in[24]        <= RxD;
							233:  key_in[23]        <= RxD;
							234:  key_in[22]        <= RxD;
							235:  key_in[21]        <= RxD;
							236:  key_in[20]        <= RxD;
							237:  key_in[19]        <= RxD;
							238:  key_in[18]        <= RxD;
							239:  key_in[17]        <= RxD;
							240:  key_in[16]        <= RxD;
							241:  key_in[15]        <= RxD;
							242:  key_in[14]        <= RxD;
							243:  key_in[13]        <= RxD;
							244:  key_in[12]        <= RxD;
							245:  key_in[11]        <= RxD;
							246:  key_in[10]        <= RxD;
							247:  key_in[9]         <= RxD;
							248:  key_in[8]         <= RxD;
							249:  key_in[7]         <= RxD;
							250:  key_in[6]         <= RxD;
							251:  key_in[5]         <= RxD;
							252:  key_in[4]         <= RxD;
							253:  key_in[3]         <= RxD;
							254:  key_in[2]         <= RxD;
							255:  key_in[1]         <= RxD;
							256:  key_in[0]         <= RxD;	
							257:  flag				<= 1'b1;
							default: data_in		<= 128'b0;
					endcase
				end
	end
endmodule //recieve_top