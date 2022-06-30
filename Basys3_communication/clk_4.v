`timescale 1ns / 1ps
//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description: clk_4.v is the top module of divided clock
// Uses modules: 
//------------------------------------------------------------------
//Clock 4 Mhz
module clk_4(
input wire clk_w5 ,//100 Mhz on board Clock
input wire reset_b ,
output reg clk
);

reg [4:0] q; //
initial clk=0;
always @(posedge clk_w5 or posedge reset_b)
    begin
        if(reset_b == 1)
            q <= 0;
        else 
            if (q<5'd24)
				q <= q+1;
			else
				begin
				clk=~clk;
				q <= 0;
				end
    end

endmodule