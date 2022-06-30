//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description: 
// Uses modules: 
//------------------------------------------------------------------
module cmod_a7_wrapper(
	input  wire		clk_L17,		// onboard 12 Mhz clock (L17 pin)
	input  wire		reset_b, 		// onboard reset	(push button)
	input  wire 	RxD, 			// data recieved through communication protocol (PMOD)
	output reg	    r_sync,			// request for synchronization from a remote device (PMOD)
	output reg		r_acknowledge,	// remote device acknoledgment in the communication protocol
	output reg		TxD,			// data which being sent through communication protocol (PMOD)
	input  wire  	basys3_sync,	// Basys3 is ready to Synchronization
	input  wire		basys3_acknowledge, // Basys3 Acknowledgement in the communication protocol 
);
wire 	    rxd_done; //LED on board
reg 		rxd_en;	  //LED on board
wire		txd_done; //LED on board
reg			txd_en	  //LED on board
reg [8:0]   bit_cntr;
reg [127:0] plain_text_128,data_in;
reg [127:0] key_128,key_in;
reg [127:0] cipher_text_128,data_out;
wire encrypt_mode,encrypt;
wire core_done;

 
	recieve_top COM_RxD(
						.clk(clk_w5),
						.reset(reset_b),
						.RxD(RxD),
						.r_sync(r_sync),
						.r_acknowledge(r_acknowledge),
						.basys3_sync(basys3_sync),
						.basys3_acknowledge(basys3_acknowledge),
						.enable(rxd_en),
						.data_in(data_in),
						.key_in(key_in),
						.encrypt(encrypt_mode),
						.ready(rxd_done)
						);
	// recieved data from Communication to basys3 registers
	always @(posedge clk_w5 or posedge reset_b)
		begin
		if (reset_b) //reset high
			begin
			plain_text_128<= 128'b0;
			key_128<= 128'b0;
			cipher_text_128<= 128'b0;
			rxd_en<=1'b1;
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
	// Encryption with the anubis algorithm (plaintext[127:0] and key[127:0] )
	anubis CORE(
				.clk(clk_w5),
				.reset(reset_b),
				.encrypt(encrypt), //encrypt or decrypt ?
				.plain_text(plain_text_128),
				.key(key_128),
				.cipher_text(cipher_text_128),
				.end_flag(core_done)
				)
	always @ (posedge clk_w5)
		begin
			if (core_done)
			begin
				data_out<= cipher_text_128;
				rxd_en<=1'b1;
				basys3_sync<=1'b1;
				basys3_acknowledge<=1'b0;
				txd_en<=1'b1;
			end
			if (basys3_sync && r_acknowledge)
				begin
					basys3_acknowledge
	transmit_top COM_TxD(
						.clk(clk_w5),
						.reset(reset_b),
						.TxD(TxD),
						.r_sync(r_sync),
						.r_acknowledge(r_acknowledge),
						.basys3_sync(basys3_sync),
						.basys3_acknowledge(basys3_acknowledge),
						.enable(txd_en),
						.data_out(data_out),
						.key_in(key_in),
						.encrypt(encrypt_mode),
						.ready(txd_done)
						);
