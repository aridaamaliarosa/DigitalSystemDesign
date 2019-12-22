module cu (clk,
			cmd_memory,addr_memory,data_memory, // data memory
			addr_program,data_program,			// program memory 
			ins_alu,in1,in2,result); 			// alu

	//clk dari luar
	//memory interface punya 3 jalur, command bolakbalik(read/write), addr(dari cpu ke memory),data bolakbalik
	//program memory interface 2 jalur, addr( dari pmi ke pm untuk kirim PC ), data ( dari pm ke pmi untuk baca mau kerjain instruksi apa)

input clk;
input [7:0] data_program, result;
output[7:0] addr_memory, addr_program, cmd_memory, ins_alu, in1, in2;
inout [7:0] data_memory;

reg [7:0] cir, operand1, operand2, pc; //Reg internal, pc nanti ke PMI
reg [7:0] temp_ins_alu, temp_in1, temp_in2; //ALU temp reg
reg [7:0] temp_addr_mem, temp_cmd_mem, temp_data_mem; //MI temp reg
reg [2:0] gpr [7:0];
reg [3:0] step;
reg data_in; //flag untuk mengubah "data_memory" menjadi input atau output

initial
	begin
		pc = 8'b00000000;
	end 
	
assign ins_alu = temp_ins_alu;
assign in1 = temp_in1;
assign in2 = temp_in2;

assign addr_memory = temp_addr_mem;
assign addr_program = pc;
assign cmd_memory = temp_cmd_mem;
assign data_memory = (data_in) ? 8'bzzzzzzzz : temp_data_mem;
	
always @ (posedge clk) 
	begin
			if(step == 4'b0001) //Baca 8-bit sebagai opcode
			begin
				cir=data_program;
				step = 4'b0010;
			end 
			else if(step == 4'b0010)
			begin
				if(cir == 8'b00000000 || cir == 8'b00010010 || cir == 8'b00001110 ) //Perintah yang tidak perlu baca PC lagi
				begin				
					if(cir == 8'b00010010) //CLR
					begin
						gpr[0][7:0]=8'b00000000;
						step=4'b1111;
					end 
					else if(cir==8'b00000000) //NOP
					begin
						step=4'b1111;
					end 
					else if(cir==8'b00001110 || cir == 8'b00010011|| cir == 8'b00010100)//CPL,RSHIFT,LSHIFT
					begin
						temp_ins_alu=cir;
						temp_in1=gpr[0][7:0];
						step= 4'b0011;
					end 
				end 
				else if(cir == 8'b00000011 || cir==8'b00000001|| cir==8'b00000010|| cir==8'b00001111|| cir==8'b00000111 || cir==8'b00010000|| cir==8'b00010001)// Perintah yang perlu baca 1x8-bit lagi
				begin
					//ADD, SUB, AND, OR, XOR, JMP, MOV antar Reg
					pc=pc+1'b1;
					step= 4'b0011;
				end 
				else if (cir == 8'b00000100 || cir == 8'b00000101 || cir == 8'b00000110 || cir == 8'b00001000 || cir == 8'b00001001 || cir == 8'b00001100 || cir == 8'b000001101) // Perintah yang butuh baca 2 operand
				begin
					//MOV Reg ke addr, MOV addr ke Reg, MOV angka ke Reg
					//JB, JNB, JZ, JNZ
					pc=pc+1'b1;
					step= 4'b0011;
				end
			end 
			else if (step == 4'b0011)
			begin
				if(cir==8'b00001110 || cir == 8'b00010011|| cir == 8'b00010100)//CPL, RSHIFT, LSHIFT
				begin
					gpr[0][7:0] = result;
					step=4'b1111;			
				end 
				else if(cir == 8'b00000011) //MOV antar reg
				begin
					operand1 = data_program;
					gpr[operand1[2:0]] = gpr[operand1[6:4]];
					step=4'b1111;
				end
				else if(cir == 8'b00000111) //JMP
				begin
					operand1 = data_program;
					pc = operand1;
					step = 4'b0001;
					
					cir = 8'b00000000;
					temp_in1 = 8'b00000000;
					data_in = 1'b1;
				end
				else if(cir==8'b00000001|| cir==8'b00000010|| cir==8'b00001111|| cir==8'b00010000|| cir==8'b00010001)  //ADD, SUB, AND, OR, XOR
				begin
					operand1 = data_program;
					temp_ins_alu = cir;
					temp_in1 = gpr[0][7:0];
					temp_in2 = gpr[operand1[2:0]][7:0];
					step = 4'b0100;
				end
				else if (cir == 8'b00000100 || cir == 8'b00000101 || cir == 8'b00000110 || cir == 8'b00001000 || cir == 8'b00001001 || cir == 8'b00001100 || cir == 8'b000001101) // Perintah yang butuh baca 2 operand
				begin
					operand1 = data_program;
					if(cir == 8'b00001000) //JB
					begin
						if(gpr[operand1[2:0]][operand1[6:4]])
						begin
							pc=pc+1'b1;
							step = 4'b0100;
						end
						else
						begin
							step=4'b1111;
						end
					end
					else if(cir == 8'b00001001) //JNB
					begin
						if(gpr[operand1[2:0]][operand1[6:4]])
						begin
							step=4'b1111;
						end
						else
						begin
							pc=pc+1'b1;
							step = 4'b0100;
						end
					end
					else if(cir == 8'b00001100) //JZ
					begin
						if(gpr[operand1[2:0]] == 8'b00000000)
						begin
							pc=pc+1'b1;
							step = 4'b0100;
						end
						else 
						begin
							step = 4'b1111;
						end
					end
					else if(cir == 8'b00001101) //JNZ
					begin
						if(gpr[operand1[2:0]] == 8'b00000000)
						begin
							step = 4'b1111;
						end
						else 
						begin
							pc=pc+1'b1;
							step = 4'b0100;
						end
					end
					else if(operand1 == 00000101) //MOV addr ke reg
					begin
						temp_addr_mem = operand1;
						temp_cmd_mem = 8'b00000000;
						data_in = 1'b1;
						pc = pc+1'b1;
						step = 4'b0100;
					end
					else
					begin
						pc=pc+1'b1;
						step = 4'b0100;
					end
				end
			end
			else if(step == 4'b0100)
			begin
				if(cir==8'b00000001|| cir==8'b00000010|| cir==8'b00001111|| cir==8'b00010000|| cir==8'b00010001)  //ADD, SUB, AND, OR, XOR
				begin
					gpr[0][7:0] = result;
					step=4'b1111;
				end
				else if (cir == 8'b00000100 || cir == 8'b00000101 || cir == 8'b00000110 || cir == 8'b00001000 || cir == 8'b00001001 || cir == 8'b00001100 || cir == 8'b000001101) // Perintah yang butuh baca 2 operand
				begin
					if(cir == 8'b00000100) //MOV Reg ke addr
					begin
						operand2 = data_program;
						temp_addr_mem = operand2;
						temp_cmd_mem = 8'b00000001; //write
						temp_data_mem = gpr[operand1[2:0]];
						data_in = 1'b0;
						step = 4'b1111;
					end
					else if(cir == 8'b00000101) //MOV addr ke reg, ambil data yang tadi di fetch
					begin
						operand2 = data_program;
						gpr[operand2[2:0]] = data_memory;
						step = 4'b1111;
					end
					else if(cir == 8'b00000110) //MOV angka ke reg
					begin
						operand2 = data_program;
						gpr[operand2[2:0]] = operand1;
						step = 4'b1111;
					end
					else if(cir == 8'b00001100 || cir == 8'b00001101 || cir == 8'b00001000 || cir == 8'b00001001 ) //JMPs
					begin
						operand2 = data_program;
						pc = operand2;
						step=4'b0001;
					end
				end
			end
			
			else if (step == 4'b1111)
			begin
				cir = 8'b00000000;
				temp_in1 = 8'b00000000;
				data_in = 1'b1;
				
				step = 4'b0001;
				pc = pc + 1'b1;
			end
	end




endmodule