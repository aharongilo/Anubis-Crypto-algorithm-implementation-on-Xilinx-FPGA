#//------------------------------------------------------------------
#// Project Name: Anubis Crypto algorithm implementation on Xilinx FPGA
#// Team Number:  xohw22-025
#// Participants: Yosef Berger, Aharon Gilo
#// Supervisor:	  Mr. Uri Stroh
#// Date:		  June 2022
#//------------------------------------------------------------------
#Basys3 by Digilent XDC file
#Artix-7 35T cpg236-1

##################
## Clock signal ##
##################
set_property PACKAGE_PIN W5 [get_ports clk_w5]
set_property IOSTANDARD LVCMOS33 [get_ports clk_w5]
create_clock -period 10.000 -name clk_w5 -waveform {0.000 5.000} -add [get_ports clk_w5]

##############
## Switches ##
##############
#set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]




##Buttons
set_property PACKAGE_PIN U18 [get_ports reset_b]
set_property IOSTANDARD LVCMOS33 [get_ports reset_b]
#set_property PACKAGE_PIN T18 [get_ports btn1]
#set_property IOSTANDARD LVCMOS33 [get_ports btn1]
#set_property PACKAGE_PIN W19 [get_ports btnL]
#set_property IOSTANDARD LVCMOS33 [get_ports btnL]
#set_property PACKAGE_PIN T17 [get_ports btnR]
#set_property IOSTANDARD LVCMOS33 [get_ports btnR]
#set_property PACKAGE_PIN U17 [get_ports btnD]
#set_property IOSTANDARD LVCMOS33 [get_ports btnD]





##Pmod Header JC
##Sch name = JC1
set_property PACKAGE_PIN K17 [get_ports {RxD}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxD}]
##Sch name = JC2
set_property PACKAGE_PIN M18 [get_ports {r_sync}]
set_property IOSTANDARD LVCMOS33 [get_ports {r_sync}]
##Sch name = JC3
set_property PACKAGE_PIN N17 [get_ports {basys3_sync}]
set_property IOSTANDARD LVCMOS33 [get_ports {basys3_sync}]
##Sch name = JC4
#set_property PACKAGE_PIN P18 [get_ports {JC[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[3]}]
##Sch name = JC7
set_property PACKAGE_PIN L17 [get_ports {TxD}]
set_property IOSTANDARD LVCMOS33 [get_ports {TxD}]
##Sch name = JC8
set_property PACKAGE_PIN M19 [get_ports {r_acknowledge}]
set_property IOSTANDARD LVCMOS33 [get_ports {r_acknowledge}]
##Sch name = JC9
set_property PACKAGE_PIN P17 [get_ports {basys3_acknowledge}]
set_property IOSTANDARD LVCMOS33 [get_ports {basys3_acknowledge}]
##Sch name = JC10
#set_property PACKAGE_PIN R18 [get_ports {JC[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[7]}]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]








