`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.6.22 21:31
// Design Name: 
// Module Name: DisplayControl
// Project Name: Songs
// Target Devices: 
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


module DisplayControl(
    input  wire	 clk,
    input  wire [3:0] enables,
    input  wire [4:0] digit3, digit2, digit1, digit0,
    output wire [3:0] an,
    output wire [6:0] segment,
    output wire dp
    );
    
    reg [4:0] current_digit;
    reg [3:0] cur_dig_AN;
    reg [6:0] segments;
    
    assign an = ~(enables & cur_dig_AN);// AN signals are active low,       
    assign dp = 1;      
                            
    reg [18:0] count, nextcount;
    
    always @(posedge clk)
         count <= nextcount;
    
    always @(posedge clk)
        nextcount = count + 1;
        
    always @(posedge clk)
      case (count[18:17])
        2'b00: begin current_digit = digit3; cur_dig_AN = 4'b1000; end  
        2'b01: begin current_digit = digit2; cur_dig_AN = 4'b0100; end
        2'b10: begin current_digit = digit1; cur_dig_AN = 4'b0010; end
        2'b11: begin current_digit = digit0; cur_dig_AN = 4'b0001; end
    endcase  
    
    always @(current_digit)
      case (current_digit)
//7 segment individual cathodes ABCDEFG
        5'b00000: segments = 7'b0000001;   //0
        5'b00001: segments = 7'b1001111;   //1
        5'b00010: segments = 7'b0100100;   //2
        5'b00011: segments = 7'b0000110;   //3
        5'b00100: segments = 7'b1001100;   //4
        5'b00101: segments = 7'b0010010;   //5 
        5'b00110: segments = 7'b0100000;   //6
        5'b00111: segments = 7'b0001111;   //7
        5'b01000: segments = 7'b0000000;   //8
        5'b01001: segments = 7'b0000100;   //9
        5'b01010: segments = 7'b0001000;   //A
        5'b01011: segments = 7'b1100000;   //B
        5'b01100: segments = 7'b1000110;   //C b0110001
        5'b01101: segments = 7'b1000010;   //d
        5'b01110: segments = 7'b0000110;   //E
        5'b01111: segments = 7'b0001110;   //F 1000111
        5'b10000: segments = 7'b0100001;   //G
        5'b10001: segments = 7'b1001000;   //H
        default: segments= 7'b1111111; //ERROR
    endcase   
    assign segment=segments; 
endmodule
