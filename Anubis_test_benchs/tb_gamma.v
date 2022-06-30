/* test bench for gamma function in teh algorithm
we won't check 2^128 - 1 numbers, that's to many,
we will check 256 numbers, to see the gamma module 
can split the input to 8 bits elements and substitute
them correctly using the sbox module
 */
`timescale 1 ns / 1 ps
module tb_gamma();

reg [127:0] data1 =0;
reg [127:0] expected = 0;
reg clk  = 0;
wire [127:0] out;
integer test_vector;
integer file_read;

always
	#100 clk = ~clk;
initial
		test_vector = $fopen("gamma_test_vector.txt","r");
		
always@(posedge clk)
	begin
		 if (!$feof(test_vector))
				begin
					file_read = $fscanf(test_vector,"%032h %032h\n",data1,expected);
				end
		 else
			$fclose(test_vector);
	end
	
always@(negedge clk)
	if (out == expected)
		begin
			$display("time = %03t | input = %032h | output = %032h | expected = %032h | PASS",
				$time,data1,out,expected);
			//$display("in binary:\n %h = %b\n %h = %b\n",data1,data1,data2,data2);
		end
	else
		begin	
			$display("time = %03t | input = %032h | output = %032h | expected = %032h | FAIL",
					$time,data1,out,expected);
			//$display("in binary:\n %h = %b\n %h = %b\n",data1,data1,data2,data2);
		end
		
		
		
gamma DUT(
.data_in(data1),
.data_out(out)
);

endmodule