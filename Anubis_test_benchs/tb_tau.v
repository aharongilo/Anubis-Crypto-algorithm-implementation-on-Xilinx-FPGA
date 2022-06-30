
`timescale 1 ns / 1 ps
module tb_tau();

reg [127:0] matrix_in;
wire [127:0] matrix_out;
reg [127:0] expected;
reg clk=0;
reg [1:0] counter = 0;
integer test_vector;
// example for in matrix:  128'h01020304050607080910111213141516
// example for out matrix: 128'h01050913020610140307111504081216

always
	#10 clk = ~clk;
	
always@(posedge clk)
	counter = counter + 1;
	
initial
	test_vector = $fopen("tau_test_vetor.txt","r");

always@(counter)
begin
	if(!$feof(test_vector))
	begin
		$fscanf(test_vector,"%032h %032h\n",matrix_in,expected);
	end
end

always@(matrix_out)
begin
	if(matrix_out == expected)
		$display("time = %03t | input = %032h | output = %032h | expected = %032h | PASS",
				$time,matrix_in,matrix_out,expected);
	else
	$display("time = %03t | input = %032h | output = %032h | expected = %032h | FAIL",
				$time,matrix_in,matrix_out,expected);
end


tau DUT(
.matrix(matrix_in),
.T_matrix(matrix_out)
);

endmodule
