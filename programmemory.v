module programmemory(addr_in, data_out);

	input [7:0] addr_in;
	output [7:0] data_out;

	reg [7:0] pm[7:0];
	
	assign data_out = pm[addr_in];
	
	initial
		begin
			// MOV 7, R2
			// MOV #12, R3
			// MOV #1, R4
			// ADD R3
			// MOV A, R1
			// CLR
			// CPL
			// SUB R4
			// MOV A, R5
			// MOV R4, A
			// LSHIFT
			// JNB R4.6, [addr dari LSHIFT]
			// RSHIFT
			// JNZ R4, [addr dari RSHIFT]
			// NOP
			// MOV R1, 3
			// JMP HERE

			// Yang kurang cuma JB dan JZ

			pm[0]  = 8'b00000101; // MOV addr ke reg
			pm[1]  = 8'b00000111; // addr 7 
			pm[2]  = 8'b00000010; // R2

			pm[3]  = 8'b00000110; // MOV direct ke reg
			pm[4]  = 8'b00001100; // #12 
			pm[5]  = 8'b00000011; // R3

			pm[6]  = 8'b00000110; // MOV direct ke reg
			pm[7]  = 8'b00000001; // #1
			pm[8]  = 8'b00000100; // R4
			
			pm[9]  = 8'b00000001; // ADD 
			pm[10] = 8'b00000011; // R3

			pm[11] = 8'b00000011; // MOV reg ke reg
			pm[12] = 8'b00000001; // A ke R1

			pm[13] = 8'b00010010; // CLR

			pm[14] = 8'b00001110; // CPL
			
			pm[15] = 8'b00000010; // SUB
			pm[16] = 8'b00000100; // R4

			pm[17] = 8'b00000011; // MOV reg ke reg
			pm[18] = 8'b00000101; // A ke R5

			pm[19] = 8'b00000011; // MOV reg ke reg
			pm[20] = 8'b01000000; // R4 ke A

			pm[21] = 8'b00010100; // LSHIFT

			pm[22] = 8'b00001001; // JNB
			pm[23] = 8'b01100100; // Bit ke-6 dari R4
			pm[24] = 8'b00010101; // Jump ke alamat LSHIFT (21)

			pm[25] = 8'b00010011; // RSHIFT

			pm[26] = 8'b00001101; // JNZ
			pm[27] = 8'b00000100; // R4
			pm[28] = 8'b00011001; // Jump ke alamat RSHIFT (25)

			pm[29] = 8'b00000000; // NOP

			pm[30] = 8'b00000100; // MOV reg ke addr
			pm[31] = 8'b00000001; // R1
			pm[32] = 8'b00000011; // Addr 3
			
			pm[33] = 8'b00000111; // JMP
			pm[34] = 8'b00100001; // HERE (33)
					
		end 
	
	
endmodule