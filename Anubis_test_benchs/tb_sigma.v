/*test bench for sigma module (bitwise xor)
in order to test all the choices, allegedly we need to test 256*256 = 65536 numbers
but, since this bitwize operation, if we will break it down we see we need to check 
all the option between only 2 bits, so all we need is 4 multiplication:
1^0, 0^1, 1^1, 0^0 
*/
`timescale 1 ns / 1 ps
module tb_sigma();

reg [127:0] data1;
reg [127:0] data2;
reg [127:0] expected = 0;
wire [127:0] out;
integer test_vector;

initial
		test_vector = $fopen("sigma_test_vetor.txt","r");
		
always
	begin
		if (! $feof(test_vector))
			begin
				$fscanf(test_vector,"%128b %128b %128b\n",data1,data2,expected);
			end
		else
			begin
				$fclose(test_vector);
				$display("closed at %t",$time);
			end
		#100;
	end
	
always@(data1)
	if (out == expected)
		begin
			$display("time = %03t | first = %h | second = %h | out = %h | expected = %h | PASS\nin binary:\n %h = %b\n %h = %b\n",
				$time,data1,data2,out,expected,data1,data1,data2,data2);
			//$display("in binary:\n %h = %b\n %h = %b\n",data1,data1,data2,data2);
		end
	else
		begin	
			$display("time = %03t | first = %h | second = %h | out = %h | expected = %h | FAIL\nin binary:\n %h = %b\n %h = %b\n",
					$time,data1,data2,out,expected,data1,data1,data2,data2);
			//$display("in binary:\n %h = %b\n %h = %b\n",data1,data1,data2,data2);
		end
		
		
		
sigma DUT(
.in1(data1),
.in2(data2),
.out(out)
);

endmodule