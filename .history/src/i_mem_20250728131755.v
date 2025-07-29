module i_mem(
  input [31:0] address,    // Endereço da instrução
  output reg [31:0] i_out  // Instrução lida
);
  
  // Memória ROM com 1024 posições (1Kb)
  reg [31:0] mem [0:1023];
  
  // Inicializa com instruções do arquivo
  initial begin
    $readmemb("sim/mem.list", mem);
  end
  
  // Leitura assíncrona (sem clock)
  always @(*) begin
    i_out = mem[address[11:2]];    // Divide por 4 (endereçamento word-aligned)
  end
endmodule

module i_mem #(
  parameter MEM_SIZE = 1024
)(
  input  wire [31:0] address,   // byte address
  output wire [31:0] i_out      // 32 bits instruction
);

  reg [31:0] mem [0:MEM_SIZE-1];
  
  initial begin
    $readmemb("sim/mem.list", mem); // load external file
  end
  
  assign i_out = mem[address[31:2]]; // address by bytes, but instructions uses 32 bits (4 bytes) 

endmodule
