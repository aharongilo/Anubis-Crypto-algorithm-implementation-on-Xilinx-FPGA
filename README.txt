# Anubis Crypto algorithm implementation on Xilinx FPGA
Implementation of Anubis algorithm for Xilinx competition, June 2022

Team Number: 					xohw22-025
Project Name:					Anubis Crypto algorithm implementation on Xilinx FPGA
Link to YouTube Video:				https:/
Link to Project repository: 			https://github.com/aharongilo/Anubis-Crypto-algorithm-implementation-on-Xilinx-FPGA

University Name:				Jerusalem College of Technology (JCT)
Participant 1:					Yosef Berger
Participant 1 E-mail:				yosefberger@gmail.com
Participant 2:					Aharon Gilo
Participant 1 E-mail:				pinhas02@gmail.com
Supervisor:					Uri Stroh
Supervisor E-mail:				stroh@jct.ac.il

Board used:					Basys 3
Software Version:				Vivado 2020.2

Description of Project:
We implemented the Anubis encryption algorithm on the Artix-7 FPGA of the Basys3 board.
To send and receive data to and from the board we used Cmod-A7 board.

Description of Archive:

Instruction to built and test the project:
Implementation: 			1. In vivado, open a new project
					2. Add all the source codes from "Anubis codes"
					3. Add the xdc constraint.
					4. Choose the required chip: Artix-7, XC7A35T1CPG236C (speed -1)
					5. Run Synthesys, Implementation and generate BitStream.
					6. Program the device.

CMOD-A7:				1. Connect the CMOD-A7 to the Basys3 according to the pins mentionned at the communication presentation
					2. Open the CMOD-A7 with Vivado.
					3. Add all the source codes from "CMOD_A7"
					4. Add the xdc constraint.
					5. Choose the required chip: Artix-7, XC7A35T1CPG236C (speed -1)
					6. Run Synthesys, Implementation and generate BitStream.
					7. Program the device.
					8. Putty:Insert the data you want to encrypt according to the instructions on the monitor.
					9. On the same window, you get the ciphertext!
Reset:					Before any new run, reset the basys3 board with the middle Push-button on it.
