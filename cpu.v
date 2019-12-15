module cpu(clk,cmd_memory,addr_memory,addr_program,data_memory,data_program);
	//clk dari luar
	//memory interface punya 3 jalur, command bolakbalik(read/write), addr(dari cpu ke memory),data bolakbalik
	//program memory interface 2 jalur, addr( dari pmi ke pm untuk kirim PC ), data ( dari pm ke pmi untuk baca mau kerjain instruksi apa)
input clk;
input [7:0] data_program;
output [7:0]addr_memory,addr_program,cmd_memory;
inout [7:0] data_memory;

//ini bagian Control Unit
//control_unit cu() 


endmodule