//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description: anubis_top.v is the top module the implementation
// Uses modules: transmit_top.v, receive_top.v, anubis.v
// Board: BASYS3 By Digilent
//------------------------------------------------------------------
module anubis_wrapper(
	input  wire		clk_w5,			// onboard 100 Mhz clock (W5 pin)
	input  wire		reset_b, 		// onboard reset	(push button U18)
	input  wire     RxD, 			// data recieved through communication protocol (PMOD)
	input  wire		r_sync,			// request for synchronization from a remote device (PMOD)
	input  wire		r_acknowledge,	// remote device acknowledgment in the communication protocol
	output wire		TxD,			// data which being sent through communication protocol (PMOD)
	output wire		basys3_acknowledge, // Basys3 Acknowledgement in the communication protocol 
	output wire  	basys3_sync// Basys3 is ready to Synchronization
);
reg 	rxd_en;	  //LED on board
reg		txd_en	; //LED on board
wire 	rxd_done; //LED on board
wire	txd_done; //LED on board
wire	[4:0] clk;
reg [127:0] plain_text_128;
wire [127:0] data_in,key_in;
reg [127:0] key_128;

wire [127:0] cipher_text_128;
reg [127:0] data_out;
wire encrypt_mode;
reg encrypt;
wire core_done;
reg basys_ack;
reg basys3_s;
wire clock_div;
assign clk=clock_div;
assign basys3_acknowledge=basys_ack;
assign basys3_sync=basys3_s;
//if (rxd_en&&~txd_en)
//	assign basys3_acknowledge = basys_ack_r;
//assign 
// Encryption/Decryption with the anubis algorithm (plaintext[127:0] and key[127:0] )
anubis CORE(
			.clk(clk_w5),
			.reset(reset_b),
			.encrypt(encrypt), //encrypt or decrypt ?
			.plain_text(plain_text_128),
			.key(key_128),
			.cipher_text(cipher_text_128),
			.end_flag(core_done)
			);
			
// 4 Mhz Clock to synchronization with CmodA7
clk_4 CLOCK(
			.clk_w5(clk_w5),
			.reset_b(reset_b),
			.clk(clock_div)
			);
//recieve data from CMOD-A7
recieve_top COM_RxD(
					.clk(clk), //4Mhz
					.reset_b(reset_b),
					.RxD(RxD),
					.r_sync(r_sync),
					.r_acknowledge(r_acknowledge),
					.basys3_sync(basys3_sync),
					.basys3_acknowledge(basys3_ack_r),
					.enable(rxd_en),
					.data_in(data_in),
					.key_in(key_in),
					.encrypt(encrypt_mode),
					.ready(rxd_done)
					);


//transmit data to CMOD-A7					
transmit_top COM_TxD(
					.clk(clk),
					.reset_b(reset_b),
					.TxD(TxD),
					.r_sync(r_sync),
					.r_acknowledge(r_acknowledge),
					.basys3_sync(basys_s),
					.basys3_acknowledge(basys3_acknowledge_t),
					.enable(txd_en),
					.data_out(data_out),
					.encrypt(encrypt_mode),
					.ready(txd_done)
					);
					
// recieved data from Communication to basys3 registers
always @(posedge clk_w5 or posedge reset_b)
begin
	if (reset_b) //reset high - initialization
	begin
		plain_text_128<= 128'b0;
		key_128<= 128'b0;
		data_out<= 128'b0;
		data_out<=128'b0;
		encrypt<=1'b0;
		rxd_en <=1'b1; // after reset idle state= waiting for data to be recieved
		txd_en <=1'b0; //
		basys3_s	 <= 1'b0;
		
		
		
	end
	else //reset is low
		
		if (rxd_en && rxd_done && basys3_acknowledge)
			if(encrypt_mode)
				begin //encryption of received data
					plain_text_128 <=  data_in;
					key_128 <= key_in;
					encrypt <=1'b1;
					rxd_en <= 1'b0; // disable recieving and changes in internal register
				end
			else	
				begin //decryption of received data
					plain_text_128 <=  data_in;
					key_128 <= key_in;
					encrypt <=1'b0;
					rxd_en <= 1'b0; // disable recieving and changes in internal register
				end
end

// Returning the ciphertext or plaintext(depends on requested core operation) to the remote device
always @ (posedge clk_w5)
begin
	if (core_done)
	begin
		data_out<= cipher_text_128;
		rxd_en<=1'b1;
		basys3_s<=1'b1; //waiting for communication
		basys_ack<=1'b0;
	end
	if (basys3_sync && r_acknowledge)
	begin
		basys_ack<=1'b1;
		txd_en<=1'b1;
	end
	if (basys3_acknowledge && txd_done)
	begin
		basys3_s<=1'b0;
		basys_ack<=1'b0;
		txd_en<=1'b0;
	end
end

endmodule //anubis_wrapper