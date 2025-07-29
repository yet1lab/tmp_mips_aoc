module d_mem(
  input clock,
  input [31:0] address,
  input [31:0] WriteData,
  output [31:0] ReadData,
  input MemWrite,
  input MemRead
);
  reg [31:0] mem [0:1023]; // Memória de 1K palavras
  
  assign ReadData = MemRead ? mem[address[11:2]] : 32'bz;
  
  always @(posedge clock) begin
    if (MemWrite)
      mem[address[11:2]] <= WriteData;
  end
endmodule