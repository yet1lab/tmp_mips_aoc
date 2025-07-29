`include "src/defines.vh"

module control(
  input [5:0] opcode,
  output reg RegDst,
  output reg Jump,
  output reg Branch,
  output reg MemRead,
  output reg MemtoReg,
  output reg [1:0] ALUOp,
  output reg MemWrite,
  output reg ALUSrc,
  output reg RegWrite,
  output reg Jr,           // Sinal para JR
  output reg ExtOp,        // Extensão de sinal
  output reg JalEn,        // Sinal para JAL
  output reg LuiEn         // Sinal para LUI
);

  always @(*) begin
    // Reset de todos os sinais
    RegDst   = 0;
    Jump     = 0;
    Branch   = 0;
    MemRead  = 0;
    MemtoReg = 0;
    ALUOp    = 2'b00;
    MemWrite = 0;
    ALUSrc   = 0;
    RegWrite = 0;
    Jr       = 0;
    ExtOp    = 1;
    JalEn    = 0;
    LuiEn    = 0;

    case (opcode)
      `MIPS_RTYPE: begin
        RegDst   = 1;
        RegWrite = 1;
        ALUOp    = 2'b10;
      end

      `MIPS_LW: begin
        ALUSrc   = 1;
        MemtoReg = 1;
        RegWrite = 1;
        MemRead  = 1;
      end

      `MIPS_SW: begin
        ALUSrc   = 1;
        MemWrite = 1;
      end

      `MIPS_BEQ: begin
        Branch = 1;
        ALUOp  = 2'b01; // Subtração
      end

      `MIPS_BNE: begin
        Branch = 1;
        ALUOp  = 2'b01; // Subtração
      end

      `MIPS_ADDI: begin
        ALUSrc   = 1;
        RegWrite = 1;
      end

      `MIPS_ANDI: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0;   // Extensão por zero
        ALUOp    = 2'b11; // Força operação AND (definir no seu código)
      end

      `MIPS_ORI: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0;   // Extensão por zero
        ALUOp    = 2'b11; // Força operação OR (definir no seu código)
      end

      `MIPS_XORI: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0;   // Extensão por zero
        ALUOp    = 2'b11; // Força operação XOR (definir no seu código)
      end

      `MIPS_J: begin
        Jump = 1;
      end

      `MIPS_JAL: begin
        Jump     = 1;
        RegWrite = 1;
        JalEn    = 1; // Sinal especial       
      end

      `MIPS_LUI: begin
        ALUSrc   = 1;
        RegWrite = 1;
        LuiEn    = 1; // Sinal especial
      end

      default: begin
        // Instruções não implementadas
      end
    endcase
  end
endmodule
