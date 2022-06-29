`timescale 1 ns / 1 ps
module tb_anubis ();

reg clk = 0;
reg reset;
reg encrypt = 1;
//reg [127:0] plain_text = 128'h84a4674fb0e8b1672d0ff03b660f5f62;
reg [127:0] plain_text = 128'h00000000000000000000000000000000;
reg [127:0] key = 128'h00000000000000000000000000000000;
reg [127:0] expected;
wire [127:0] cipher_text;
wire end_flag;
integer test_vector;
integer file_read;
	
initial
begin
	reset <= 1;
	#40 reset <= 0;
end	

initial
begin
	test_vector = $fopen("anubis_test_vector.txt","r");
end

always
begin
	#10 clk <= ~clk;
end

always@(posedge end_flag)
begin
	if (!$feof(test_vector))
	begin
		file_read = $fscanf(test_vector,"%032h %032h %032h\n",key,plain_text,expected);//expected,plain_text);
		reset <= 1;
		#40 reset <= 0;
	end
	else
		$fclose(test_vector);
end

always@(posedge end_flag)
begin
	$display("time: %03t | key: %32h | plain: %032h | cipher: %032h | next expected cipher: %032h",
				$time,key,plain_text,cipher_text,expected);
end
	


anubis DUT (
.clk(clk),
.reset(reset),
.encrypt(encrypt),
.plain_text(plain_text),
.key(key),
.cipher_text(cipher_text),
.end_flag(end_flag)
);

endmodule