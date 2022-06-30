
`timescale 1 ns / 1 ps
module tb_theta( );
reg clk = 0;
reg tb_clk = 0;
reg [127:0] data_in;
reg [127:0] expected;
wire [127:0] data_out;
//reg [31:0] data_in=0;
//reg [31:0] expected=0;
//wire [31:0] data_out;
integer test_vector;
integer file_read;
//wire [7:0] temp13,temp14,temp15,temp16;

always
	#10 clk = ~clk;
	
initial
	begin
		#100
		forever #30 tb_clk = ~tb_clk;
	end

initial
	//test_vector = $fopen("row_test_vector.txt","r");
	test_vector = $fopen("omega_test_vetor.txt","r");
	
always@(posedge tb_clk)
	begin
		 if (!$feof(test_vector))
				begin
					file_read = $fscanf(test_vector,"%032h %032h\n",data_in,expected);
					//file_read = $fscanf(test_vector,"%08h %08h\n",data_in,expected);
				end
		 else
			$fclose(test_vector);
	end

always@(data_in)
	$display("time = %03t | input = %032h | output(for last input = %032h | next expected data = %032h",
				$time,data_in,data_out,expected);

omega DUT(
.clk(clk),
.key(data_in),
.extract_key(data_out)
);

/*
theta DUT(
.clk(clk),
.data_in(data_in),
.deffused_data(data_out)
);
*/
/*
mult_row DUT(
.clk(clk),
.row(data_in),
.result(data_out),
.temp13(temp13),
.temp14(temp14),
.temp15(temp15),
.temp16(temp16)
);
*/
endmodule