/*test bench for the sbox module*/

`timescale 1 ns / 1 ps

module tb_sbox();

wire [7:0] data_out;
reg [7:0] counter = 0;
reg [7:0] insert;
reg [7:0] result = 0;
integer test_vector;

	
initial	
	test_vector = $fopen("sbox_testVector.txt","r");

always
		#10 counter = counter + 1;
always
	#10
	if (! $feof(test_vector))
		begin 
			$fscanf(test_vector,"%h %h\n",insert,result);
		end
	else
		$fclose(test_vector);
	
		
always@(result)
	if (result == data_out)
		$display("time = %3t | input = %02h | output = %02h | expected = %02h | PASS",
				$time,insert,data_out,result);
	else
		$display("time = %8t | input = %08h | output = %08h | expected = %08h | FAIL",
				$time,insert,data_out,result);
	
sbox DUT (
.in (insert),
.out(data_out) 
);
	
endmodule