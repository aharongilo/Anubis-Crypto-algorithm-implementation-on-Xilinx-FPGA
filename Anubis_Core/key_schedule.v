//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description:  the key_schedule module represent the key schedule in the algorithm.
//				 it's create the key rounds for all the rounds
// used modules: key_evolution, key_selection
//------------------------------------------------------------------
module key_schedule(
	input clk,
	input reset,
	input encrypt,
	input load,
	input [3:0] counter,
	input [127:0] key,
	input [127:0] round_constant,
	output [127:0] round_key,
	output [3:0] key_number
);

reg state;
reg [3:0] cycle_number;// number of the "round" when creating the round keys
reg [127:0] evolutioned_key,selected_key;
wire [127:0] step1,step2;

// constant for the state machine
localparam F_KEY_EVOLUTION = 0;
localparam F_KEY_SELECTION = 1;

//nested modules
key_evolution first(clk,reset,counter,~state,cycle_number,key,round_constant,step1);
key_selection second(clk,reset,encrypt,cycle_number,counter,state,evolutioned_key,step2);

// state we're in for state machine
always@(negedge clk)
begin
	if (reset)
		state <= 1;
	else 
		if (counter == 4'hf)
			state <= state + 1;
end


// state machine, code timing
always@(negedge clk)
begin
	if (reset)
	begin
		cycle_number <= 0;
		evolutioned_key <= key;
	end
	else 
	begin	
		if (load)
		begin
			if (counter == 4'hf)
				case(state)
					F_KEY_EVOLUTION:begin
										evolutioned_key <= step1;
									end
					F_KEY_SELECTION: begin
										selected_key <= step2;
										if (cycle_number < 12)
											cycle_number <= cycle_number + 1;
										else
											cycle_number <= 13;
									 end
				endcase
		end
	end
end

// update the output of the module
assign round_key = selected_key;
assign key_number = cycle_number;
endmodule