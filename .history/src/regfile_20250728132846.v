module regfile(
  input clock,
  input reset,
  input RegWrite,        // Habilita escrita
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

  // Escrita síncrona (reset asspincrono)
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

module regfile (
  input wire clk,
  input wire reset,
  input wire RegWrite,
  input wire [4:0] ReadAddr1,
  input wire [4:0] ReadAddr2,
  input wire [4:0] WriteAddr,
  input wire [31:0] WriteData,
  output wire [31:0] ReadData1,
  output wire [31:0] ReadData2
);

  reg [31:0] regs [31:0];  // Banco de 32 registradores de 32 bits

  integer i;

  // Reset síncrono: zera todos os registradores
  always @(posedge clk) begin
    if (reset) begin
      for (i = 0; i < 32; i = i + 1)
        regs[i] <= 32'b0;
    end else if (RegWrite) begin
      if (WriteAddr != 0)       // Registrador 0 é sempre 0, não pode ser escrito
        regs[WriteAddr] <= WriteData;
    end
  end

  // Leitura assíncrona
  assign ReadData1 = (ReadAddr1 == 0) ? 32'b0 : regs[ReadAddr1];
  assign ReadData2 = (ReadAddr2 == 0) ? 32'b0 : regs[ReadAddr2];

endmodule
