//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description:  This module is the top module of the algorithm itself.
//				 It derive the whole algorithm. It will output the result of
//				 the calculations.
// used modules: sigma, key_schedule, round
//------------------------------------------------------------------

module anubis(
	input clk,
	input reset,
	input encrypt,
	input [127:0] plain_text,
	input [127:0] key,
	output [127:0] cipher_text,
	output end_flag
);

reg state;
reg done;
reg [3:0] counter = 0;
reg [3:0] round_num;
reg [127:0] round_in,current_round_key,cipher;
reg [127:0] selection_round0,round_key1,round_key2,round_key3,round_key4,round_key5,round_key6,round_key7,round_key8,round_key9,round_key10,round_key11,round_key12;
wire [127:0] step0,step1,step2;
wire [3:0] key_schedule_round;

//round constans:
reg [127:0] round_constant1 = 128'h00000000000000000000000071e6d3a7;
reg [127:0] round_constant2 = 128'h000000000000000000000000794dacd0;
reg [127:0] round_constant3 = 128'h000000000000000000000000fc91c93a;
reg [127:0] round_constant4 = 128'h000000000000000000000000bd54471e;
reg [127:0] round_constant5 = 128'h000000000000000000000000fb7aa58c;
reg [127:0] round_constant6 = 128'h000000000000000000000000d4ddb863;
reg [127:0] round_constant7 = 128'h000000000000000000000000bec5b3e5;
reg [127:0] round_constant8 = 128'h000000000000000000000000a20c88a9;
reg [127:0] round_constant9 = 128'h000000000000000000000000da29df39;
reg [127:0] round_constant10 = 128'h0000000000000000000000004ccba82b;
reg [127:0] round_constant11 = 128'h00000000000000000000000024aa224b;
reg [127:0] round_constant12 = 128'h000000000000000000000000f9a67041;
reg [127:0] current_round_constant;

localparam key_schedule = 0;
localparam round = 1;

sigma pre(selection_round0,plain_text,step0);
key_schedule first(clk,reset,encrypt,~state,counter,key,current_round_constant,step1,key_schedule_round);
round second(clk,reset,counter,state,round_num,round_in,current_round_key,step2);

always@(posedge clk)
begin
	if (reset)
	begin
		counter <= 0;
	end
	else
	begin
		if (done)
			counter <= 0;
		else
			counter <= counter + 1;
	end
end


always@(posedge clk)
begin
	if (reset)
		state <= 0;
	else
		begin
			if (key_schedule_round >12)
				state <= 1;
				round_in <= step0;
		end
end
/*
always@(posedge clk)
begin
	if (~state)
		if (key_schedule_round == 12)
			round_in <= step0;
end
*/
/*proccess for round constant*/
always@(negedge clk)
begin
	if (reset)
	begin
		current_round_constant <= round_constant1;
	end
	else
	begin
		if (state)
		begin
			case(round_num)
					4'd1: current_round_constant <= round_constant1;
					4'd2: current_round_constant <= round_constant2;
					4'd3: current_round_constant <= round_constant3;
					4'd4: current_round_constant <= round_constant4;
					4'd5: current_round_constant <= round_constant5;
					4'd6: current_round_constant <= round_constant6;
					4'd7: current_round_constant <= round_constant7;
					4'd8: current_round_constant <= round_constant8;
					4'd9: current_round_constant <= round_constant9;
					4'd10: current_round_constant <= round_constant10;
					4'd11: current_round_constant <= round_constant11;
					4'd12: current_round_constant <= round_constant12;
					default: current_round_constant <= round_constant1;
				endcase
		end
		else
		begin
			case(key_schedule_round)
				4'd1: current_round_constant <= round_constant1;
				4'd2: current_round_constant <= round_constant2;
				4'd3: current_round_constant <= round_constant3;
				4'd4: current_round_constant <= round_constant4;
				4'd5: current_round_constant <= round_constant5;
				4'd6: current_round_constant <= round_constant6;
				4'd7: current_round_constant <= round_constant7;
				4'd8: current_round_constant <= round_constant8;
				4'd9: current_round_constant <= round_constant9;
				4'd10: current_round_constant <= round_constant10;
				4'd11: current_round_constant <= round_constant11;
				4'd12: current_round_constant <= round_constant12;
				default: current_round_constant <= round_constant1;
			endcase
		end
	end
end

always@(key_schedule_round)
begin
	if (encrypt)
	begin
		case(key_schedule_round)
			1: selection_round0 <=step1 ;
			2: round_key1 <= step1;
			3: round_key2 <= step1;
			4: round_key3 <= step1;
			5: round_key4 <= step1;
			6: round_key5 <= step1;
			7: round_key6 <= step1;
			8: round_key7 <= step1;
			9: round_key8 <= step1;
			10: round_key9 <= step1;
			11: round_key10 <= step1;
			12: round_key11 <= step1;
			13: round_key12 <= step1;
		endcase
	end
	else
	begin
		case(key_schedule_round)
			1: round_key12 <= step1;
			2: round_key11 <= step1;
			3: round_key10 <= step1;
			4: round_key9 <= step1;
			5: round_key8 <= step1;
			6: round_key7 <= step1;
			7: round_key6 <= step1;
			8: round_key5 <= step1;
			9: round_key4 <= step1;
			10: round_key3 <= step1;
			11: round_key2 <= step1;
			12: round_key1 <= step1;
			13: selection_round0 <=step1 ;
		endcase
	end
end

always@(posedge clk) //selected round key
begin
	case(round_num)
		1: current_round_key <= round_key1;
		2: current_round_key <= round_key2;
		3: current_round_key <= round_key3;
		4: current_round_key <= round_key4;
		5: current_round_key <= round_key5;
		6: current_round_key <= round_key6;
		7: current_round_key <= round_key7;
		8: current_round_key <= round_key8;
		9: current_round_key <= round_key9;
		10: current_round_key <= round_key10;
		11: current_round_key <= round_key11;
		12: current_round_key <= round_key12;
		default: current_round_key <= 0;
	endcase
end


always@(posedge clk)
begin
	if (reset)
		round_num <= 1;
	else
		if (done)
			round_num <= 13;
		else
			//if start: round_num <= 1;
			if (state)
				if (counter == 4'hf)
					round_num <= round_num + 1;	
end

always@(round_num)
begin
	if (reset)
		done <= 0;
	else
		if (round_num > 12)
			done <= 1;
		else
			done <= 0;
end

always@(round_num)
begin
	if (reset)
		cipher <= 0;
	else
		if (round_num > 12)
			cipher <= step2;
end

assign end_flag = done;
assign cipher_text = cipher;

endmodule