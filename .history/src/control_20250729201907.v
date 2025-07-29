`include "src/defines.vh"

module control(
  input [5:0] opcode,
  input [5:0] funct,       // Para detectar JR
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
    ALUOp    = `ALUOP_LW_SW_ADDI;
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
        ALUOp    = `ALUOP_RTYPE;
        Jr       = (funct == `FUNCT_JR) ? 1 : 0;
      end

      `MIPS_ADDI: begin   // I.1
        ALUSrc   = 1;
        RegWrite = 1;
      end

      `MIPS_ANDI: begin   // I.2
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0;     // Extensão por zero
        ALUOp    = `ALUOP_ANDI_ORI_XORI;
      end

      `MIPS_ORI: begin    // I.3
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0;     // Extensão por zero
        ALUOp    = `ALUOP_ANDI_ORI_XORI;
      end

      `MIPS_XORI: begin   //I.4
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0;     // Extensão por zero
        ALUOp    = `ALUOP_ANDI_ORI_XORI;
      end

      `MIPS_BEQ: begin    // I.5
        Branch = 1;
        ALUOp  = `ALUOP_BEQ_BNE;
      end

      `MIPS_BNE: begin    // I.6
        Branch = 1;
        ALUOp  = `ALUOP_BEQ_BNE;
      end
// FALTA I.7
      `MIPS_SLTIU: begin   // I.8
        ALUSrc    = 1;     // usa imediato
        RegDst    = 0;     // escreve em rt
        RegWrite  = 1;
        MemtoReg  = 0;
        MemRead   = 0;
        MemWrite  = 0;
        Branch    = 0;
        Jump      = 0;
        ALUOp     = 2'b11; // novo valor que indicará operação SLTIU na ula_ctrl
      end
      
      `MIPS_LUI: begin // I.9
        ALUSrc   = 1;
        RegWrite = 1;
        LuiEn    = 1;
      end
      
      `MIPS_LW: begin  // I.10
        ALUSrc   = 1;
        MemtoReg = 1;
        RegWrite = 1;
        MemRead  = 1;
      end

      `MIPS_SW: begin  // I.11
        ALUSrc   = 1;
        MemWrite = 1;
      end
//================================================
      `MIPS_J: begin   // J.1
        Jump = 1;
      end

      `MIPS_JAL: begin // J.2
        Jump     = 1;
        RegWrite = 1;
        JalEn    = 1;
      end

      default: begin
        // NÃO FAZ NADA
      end
    endcase
  end
endmodule
