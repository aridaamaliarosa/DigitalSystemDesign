module datamemory(cmd_in, addr_in, data)

	input [7:0] addr_in;
	input cmd_in;
	inout [7:0] data;
	
	reg [7:0] dmemory[20:0];
	
	reg tempData [7:0];
		
	always @(posedge clk)	
		begin
			if (cmd_in = 1'b0) //read
				begin 
					tempData = dm[addr_in];
				end
				
			else if (cmd_in = 1'b1) //write
				begin	
					tempData=0;
					dm[addr_in] = data;
				end
					
		end
	assign data = tempData;
		
	initial
	begin
 		dm[0000 0000] = 0
		dm[0000 1010] = 10
		dm[0001 0100] = 20
		dm[0000 0101] = 5
		dm[0001 0110] = 22
		dm[0000 0111] = 7
		dm[0001 1011] = 27
		dm[0000 0011] = 3
		dm[0001 1010] = 26
		dm[0001 1111] = 31
		dm[0010 0100] = 36
		dm[0000 1110] = 14
		dm[0001 1101] = 29
		dm[0010 0001] = 33
		dm[0010 1010] = 42
		dm[0001 0001] = 17
		dm[0001 1000] = 24
		dm[0010 0101] = 37
		dm[0011 0011] = 51
		dm[0011 0111] = 55
	end
	
	
endmodule;