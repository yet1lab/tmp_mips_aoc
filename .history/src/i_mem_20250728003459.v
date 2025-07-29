
module i_mem(
  input [31:0] address,    // Endereço da instrução
  output reg [31:0] i_out  // Instrução lida
);
  
  // Memória ROM com 1024 posições (1Kb)
  reg [31:0] mem [0:1023];
  
  // Inicializa com instruções do arquivo
  initial begin
    $readmemb("instruction.list", mem);
  end
  
  // Leitura assíncrona (sem clock)
  always @(*) begin
    i_out = mem[address[11:2]];    // Divide por 4 (endereçamento word-aligned)
  end
endmodule

