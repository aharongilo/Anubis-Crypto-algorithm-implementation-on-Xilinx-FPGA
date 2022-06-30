`timescale 1 ns / 1 ps
module tb_key_selection();

reg clk = 0;
//reg clk_en;
reg reset=1;
reg load_key;
reg [127:0] in_key;
reg [127:0] sigma;
reg [127:0] expected_result;
wire [127:0] out;
reg [3:0] counter = 4'b0000;

integer test_vector;

always
	#10 clk = ~clk;
	
initial
	#35 reset = 0;
	
always@(out)
begin
	load_key <= 1;
	#20 load_key <= 0;
end

always@(posedge clk)
begin 
	if (reset)
		counter <= 0;
	else
		if (load_key)
			counter <= 0;
		else
			counter = counter+1;
end

initial
	test_vector = $fopen("key_selection_test_vector.txt","rb");

always@(posedge load_key)
begin
	 if (!$feof(test_vector))
		$fscanf(test_vector,"%032h %032h\n",in_key,expected_result);
	 else
		$fclose(test_vector);
end

always@(posedge load_key)
	$display("time = %03t | key = %32h | expected evolutioned_key = %32h | last evolutioned_key = %32h",
			   $time,in_key,expected_result,out);


//assign expected_result = out^sigma;

key_selection DUT (
.clk(clk),
//.clk_en(clk_en),
.reset(reset),
.counter(counter),
.load_key(load_key),
.evolutioned_key(in_key),
.round_key(out)
);
endmodule
