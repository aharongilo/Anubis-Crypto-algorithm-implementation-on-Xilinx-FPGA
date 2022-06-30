//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description:  key_evolution.v represent the first function of the key schedule in the algorithm.
// Uses modules: gamma.v, pi.v, theta.v, sigma.v
//------------------------------------------------------------------
module key_evolution(
	input clk,
	input reset,
	input [3:0] counter,
	input load_key,
	input [3:0] round_num,
	input [127:0] key,
	input [127:0] round_constant,
	output [127:0] evolutioned_key
);

// constant for the state machine
localparam F_GAMMA = 2'b00;
localparam F_PI   = 2'b01;
localparam F_THETA = 2'b10;
localparam F_SIGMA = 2'b11;

wire [127:0] step1,step2,step3,step4;
reg [127:0] gamma_out, pi_out, theta_out,out_psi,key_in;
reg [1:0] state;
reg clk_en;

// clock enable, states when to save functions output in
// the registers
always@(posedge clk)
begin
	if (reset)
		clk_en <= 0;
	else
		if (counter%4 == 3)
			clk_en <= 1;
		else
			clk_en <= 0;
end

//nested modules
gamma ps1(key_in,step1);
pi ps2(gamma_out,step2);
theta ps3(clk,pi_out,step3);
sigma ps4(round_constant,theta_out,step4);

// state machine, code timing
always@(posedge clk)
begin
	if (reset)
	begin
		state <= F_GAMMA;
		out_psi <= 0;
	end
	else
	begin
		if (load_key == 1)
			case(state)
				F_GAMMA: if (clk_en)
							begin
								state <= F_PI;
								gamma_out <= step1;
							end
				F_PI: if (clk_en)
						begin
							state <= F_THETA;
							pi_out <= step2;
						end
				F_THETA: if (clk_en)
							begin
								state <= F_SIGMA;
								theta_out <= step3;
							end
				F_SIGMA: if (clk_en)
							begin
								state <= F_GAMMA;
								out_psi <= step4;
							end
			endcase
	end
end

/*in this module, the input of round k for k>1 is the output of
 the last round. this process get the output back as a input in
 the relevant rounds*/
always@(negedge clk)
begin
	if(reset)	
	begin
		key_in <= key;
	end
	else
	begin
		if (load_key)
			if (round_num == 1)
				key_in <= key;
			else if (round_num == 0)
				key_in <= key;
			else
				key_in <= out_psi;
	end
end		

// update the output of the module
assign evolutioned_key = out_psi;

endmodule //key_evolution