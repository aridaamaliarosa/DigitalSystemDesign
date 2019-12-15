module alu(op,in1, in2, result, clk);
	input clk;
	input [7:0] op, in1, in2;
	output [7:0] result;
	
	reg[7:0] hasil;
	
	always @ (posedge clk) 
	begin
		if (op == 8'b00000001)//ADD
		begin
			hasil <= in1 + in2;
		end
		//slesai	
	
		else if (op == 8'b00000010)//SUB
		begin 
			hasil <= in1 - in2;
		end 
		//slesai
	
		else if (op == 8'b00001111)//AND	
		begin 
			hasil <= in1 & in2;
		end
		//slesai
	
		else if (op == 8'b00010000)//OR
		begin 
			hasil <= in1 | in2;
		end
		//slesai

		else if (op == 8'b00001110)//CPL
		begin 
			hasil <= in1 + 11111111;
		end 
		//slesai

		else if (op == 8'b00010001)//XOR
		begin 
			hasil <= in1 ^ in2;
		end 
		//slesai
	end
	
	assign result = hasil;
endmodule