//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description:  key_selection.v represent the second function of the key schedule in the algorithm.
// Uses modules: gamma.v, omega.v, tau.v, theta.v
//------------------------------------------------------------------

module key_selection(
	input clk,
	input reset,
	input encrypt,
	input [3:0] round_num,
	input [3:0] counter,
	input load_key,
	input [127:0] evolutioned_key,
	output [127:0] round_key
);

// constant for the state machine

localparam F_GAMMA = 2'b00;
localparam F_OMEGA = 2'b01;
localparam F_TAU   = 2'b10;
localparam DECRYPT = 2'b11;

wire [127:0] step1,step2,step3,step4;
reg [127:0] gamma_out,omega_out,tau_out,theta_out,selected_key;
reg [1:0] state;
reg clk_en;

// clock enable, to know when to save functions output in
// the registers
always@(posedge clk)
begin
	if (reset)
		clk_en <= 0;
	else
		if (counter%4 == 1)
			clk_en <= 1;
		else
			clk_en <= 0;
end

// nested modules
gamma sk1(evolutioned_key,step1);
omega sk2(clk,gamma_out,step2);
tau sk3(omega_out,step3);
theta decrypt (clk,tau_out,step4);

// state machine, code timing
always@(posedge clk)
begin
	if (reset)
	begin
		state <= F_GAMMA;
		selected_key <= 0;
	end
	else
	begin
		if (load_key == 1)
			case(state)
				F_GAMMA: if (clk_en)
							begin
								state <= F_OMEGA;
								gamma_out <= step1;
							end
				F_OMEGA: if (clk_en)
							begin
								state <= F_TAU;
								omega_out <= step2;
							end
				F_TAU: if (clk_en)
						begin
							state <= DECRYPT;
							if (encrypt)
							begin
								selected_key <= step3;
							end
							else
							begin
								if (round_num == 0)
									selected_key <= step3;
								else if (round_num == 12)
									selected_key <= step3;
								else
									selected_key <= selected_key;
								tau_out <= step3;
							end
						end
				DECRYPT: if (clk_en)
							begin
								state <= F_GAMMA;
								if (encrypt == 0)
									if (round_num == 0)
										selected_key <= tau_out;
									else if (round_num < 12)
										selected_key <= step4;
									else if (round_num == 12)
										selected_key <= tau_out;
									else
										selected_key <= selected_key;
							end
			endcase
	end
end


assign round_key = selected_key;

endmodule //key_selection
