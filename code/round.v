//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description:  round module represent the rouond function in the algorithm.
//				 after all the rounds we will get the cipher text				 
// used modules: gamma, tau, theta, sigma
//------------------------------------------------------------------
module round(
	input clk,
	input reset,
	input [3:0] counter,
	input load_text,
	input [3:0] round_number, // in the 12th round, we don't do sigma
	input [127:0] plain_text,
	input [127:0] round_key,
	output [127:0] round_cipher_text
);

// constant for the state machine
localparam F_GAMMA = 2'b00;
localparam F_TAU   = 2'b01;
localparam F_THETA = 2'b10;
localparam F_SIGMA = 2'b11;

wire [127:0] step1,step2,step3,step4;
reg [127:0] gamma_out, tau_out, theta_out,cipher,data_in;
reg [1:0] state;
reg clk_en;
reg [127:0] round_plain_text;

// nested modules
gamma s1(round_plain_text,step1);
tau s2(gamma_out,step2);
theta s3(clk,tau_out,step3);
sigma s4(round_key,theta_out,step4);

// clock enable, to know when to save functions output in
// the registers
always@(posedge clk)
begin
	if (reset)
		clk_en <= 0;
	else
		if (load_text)
			clk_en <= 1;
		else
			if (counter%4 == 3)
				clk_en <= 1;
			else
				clk_en <= 0;
end

// state machine, code timing
always @(negedge clk)
begin
	if (reset)
	begin
		state <= F_GAMMA;
		cipher <= 0;
	end	
	else
	begin
			case(state)
				F_GAMMA: if (clk_en)
							begin
								state <= F_TAU;
								gamma_out <= step1;
							end
				F_TAU:   if (clk_en)
							begin
								if (round_number == 12)
								begin
									state <= F_SIGMA;
								end
								else
								begin
									state <= F_THETA;
								end
								tau_out <= step2;
							end
				F_THETA: if (clk_en)
							begin						
								state <= F_SIGMA;
								theta_out <= step3;
							end
				F_SIGMA: if (clk_en)
							begin
								state <= F_GAMMA;
								cipher <= step4;
							end
			endcase
	end
end

/*in this module, the input of round k for k>1 is the output of
 the last round. this process get the output back as a input in
 the relevant rounds*/
always@(negedge clk)
begin
	if (reset)
	begin 
		round_plain_text <= plain_text;
	end
	else
	begin
		if (load_text)
		begin
			if (round_number == 1)
				round_plain_text <= plain_text;
			else
				round_plain_text <= cipher;
		end
	end
end

// update the output of the module
assign round_cipher_text = cipher;

endmodule