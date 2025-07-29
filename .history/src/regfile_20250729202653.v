module regfile(
  input clock,
  input reset,
  input RegWrite,            // Habilita escrita
  input [4:0] ReadAddr1,     // Endereço rs (Register Source)
  input [4:0] ReadAddr2,     // Endereço rt (Register Target)
  input [4:0] WriteAddr,     // Endereço rd (Register Destination/Tipo R)
  input [31:0] WriteData,    // Dado a Escrever
  output [31:0] ReadData1,   // Valor de rs
  output [31:0] ReadData2    // Valor de rt             
);
  reg [31:0] registers [0:31];  // 32 Registradores

  // Leitura assíncrona
  assign ReadData1 = (ReadAddr1 == 0) ? 32'b0 : registers[ReadAddr1];
  assign ReadData2 = (ReadAddr2 == 0) ? 32'b0 : registers[ReadAddr2];

  // Escrita síncrona (reset assincrono)
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      for (integer i = 0; i < 32; i++)
        registers[i] <= 0;        // Zera todos os registradores
    end
    else if (RegWrite && WriteAddr != 0) begin
      registers[WriteAddr] <= WriteData;  // Escreve em rd (exceto $zero)
    end
  end
endmodule
