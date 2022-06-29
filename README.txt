# Anubis Crypto algorithm implementation on Xilinx FPGA
Implementation of Anubis algorithm for Xilinx competition, June 2022

Team Number: 					xohw22-025
Project Name:					Anubis Crypto algorithm implementation on Xilinx FPGA
Link to YouTube Video:				https:/
Link to Project repository: 			https://github.com/aharongilo/Anubis-Crypto-algorithm-implementation-on-Xilinx-FPGA

University Name:				Jerusalem College of Technology (JCT)
Participant 1:					Yosef Berger
Participant 1 E-mail:				cudkowic@g.jct.ac.il
Participant 2:					Aharon Gilo
Participant 1 E-mail:				pinhas02@gmail.com
Supervisor:					Uri Stroh
Supervisor E-mail:				stroh@jct.ac.il

Board used:					Basys 3
Software Version:				Vivado 2020.2

Description of Project:
We implemented the Anubis encryption algorithm on the Artix-7 FPGA of the Basys3 board.
To send and receive data to and from the board we used Cmod board.

Description of Archive:

Instruction to built and test the project:
Implementation: 			1. In vivado, open a new project
					2. Add all the source codes from "Hummingbird-2 codes"
					3. Add the xdc constraint.
					4. Choose the required chip: Artix-7, XC7A35T1CPG236C (speed -1)
					5. Run Synthesys, Implementation and generate BitStream.
					6. Program the device.
Arduino:				1. Connect the Arduino Nano ATmega 328p to the Basys3 according to the pins mentionned at the beggining of the arduino code
					and the constraint table from the report (table 1).
					2. Open the arduino code with Arduino 1.8.13 tool.
					3. Run the arduino code and open the serial monitor on the tool.
					4. Insert the data you want to encrypt according to the instruction on the monitor.
					5. On the same window, you get the ciphertext!
Reset:					Before any new run, reset the basys3 board with the middle Push-button on it.
