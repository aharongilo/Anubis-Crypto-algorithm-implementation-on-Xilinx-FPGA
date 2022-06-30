
//------------------------------------------------------------------
// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
// Team Number:  xohw22-025
// Participants: Yosef Berger, Aharon Gilo
// Supervisor:	 Mr. Uri Stroh
// Date:		 June 2022
// Description: d_s_control.v Control the a standard speaker and the seven segment onboard BASYS3
// Uses modules: DisplayControl.v , SpeakerControl.v
// Board: BASYS3 By Digilent
//------------------------------------------------------------------
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JCT Jerusalem College of technology 
// Engineer: 
// 
// Create Date: 22.6.22 21:37
// Design Name: 
// Module Name: DisplayControl
// Project Name: Anubis 
// Target Devices: basys3
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_display_and_speaker(
    input wire clk,
    input wire [15:0] sw,
    output wire sound,
    output wire [3:0] an,
    output wire [6:0] segment,//segment
    output wire dp
    );
    
    reg [3:0] enables;
    reg [4:0] digit3, digit2,digit1, digit0;
    reg [15:0] count;
    reg [4:0] note; 
    reg [16:0] duration;
    reg clear, dclk;
    
    always @(posedge clk)
        if (count > 0)
			count = count-1;                             //generates new clock 
        else
			begin
				count <= 50_000;
				dclk <= ~dclk; //so we can use duration as mili second
			end      
    
    always @(posedge dclk) 
    begin
            if (clear) 
			     duration = 0;
            else 
			duration = duration + 1;
    end

    DisplayControl dc(clk, enables, digit3, digit2,digit1, digit0, an, segment, dp);    
    SpeakerControl sc(clk, note, sound);  
   
    always @ (posedge clk)
      case (note)
        5'b00000: begin digit3 = 5; digit2 =10; digit1=15;digit0=14; enables = 4'b1111;  end      //SAFE
        5'b11110: begin digit3 = 15; digit2=10;digit1=5;  digit0 = 5; enables = 4'b1111;  end      	  //PASS
        5'b11111: begin digit3 = 15; digit2 = 10;digit1=1; digit0 = 1; enables = 4'b1111;  end           //FAIL        
       
      endcase


    always @ (posedge clk)
      case(sw)//Mvp - insted of sw, For Anubis will be control bits
        16'b0000000000000001:   begin  
                                clear <= 0;
//                       
                                if(500 > duration)
                                    note <= 5'b00000; //"SAFE"
								else if(75500 > duration)  
                                    note <= 5'b00001; //"PASS"
								else if( 90000>duration)
									note<=5'b00010;   //"FAIL"
								end
//        16'b0000000000000010:   
//        16'b0000000000000100:                       
//        16'b0000000000001000:
//        16'b0000000000010000:
//        16'b0000000000100000:
//        16'b0000000001000000:
//        16'b0000000010000000:
//        16'b0000000100000000:        
//        16'b0000001000000000:
//        16'b0000010000000000:
//        16'b0000100000000000:
//        16'b0001000000000000:        
//        16'b0010000000000000:
//        16'b0100000000000000:
//        16'b1000000000000000:
        default: begin clear <= 1; note = 0; end
      endcase

  
endmodule
