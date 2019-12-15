module programmemory(addr_in, data_out)

	input [7:0] addr_in;
	output [7:0] data_out;
	
	assign data_out=pmemory[addr_in];
	
	initial
		begin
			pm[0]=8'b00000000 //NOP
			
			pm[1]= 8'b00000110//MOV Angka ke Register 
			pm[2]= 8'b01010000//operand 1 = masukin angka 80d	
			pm[3]= 8'b00000010//Register2
			
			pm[4]= 8'b00000100//MOV Register ke Alamat
			pm[5]= 8'b00000010//Register2
			pm[6]= 8'b11010000//alamat 208
			
			//pm[7]= 		// ADD dari Register 
					//JMP
					//AND
					//CLR
					//LSHIFT 
					
		end 
	
	
endmodule;