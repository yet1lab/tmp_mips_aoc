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
        ALUOp  = `ALUOP_BEQ_BNE;
      end

      `MIPS_BNE: begin
        Branch = 1;
        ALUOp  = `ALUOP_BEQ_BNE;
      end

      `MIPS_ADDI: begin
        ALUSrc   = 1;
        RegWrite = 1;
      end

      `MIPS_ANDI: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0;   // Extensão por zero
        ALUOp    = `ALUOP_ANDI_ORI_XORI;
      end

      `MIPS_ORI: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0;   // Extensão por zero
        ALUOp    = `ALUOP_ANDI_ORI_XORI;
      end

      `MIPS_XORI: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0;   // Extensão por zero
        ALUOp    = `ALUOP_ANDI_ORI_XORI;
      end

      `MIPS_J: begin
        Jump = 1;
      end

      `MIPS_JAL: begin
        Jump     = 1;
        RegWrite = 1;
        JalEn    = 1;
      end

      `MIPS_LUI: begin
        ALUSrc   = 1;
        RegWrite = 1;
        LuiEn    = 1;
      end

      `MIPS_SLTIU: begin
        ula_src   = 1;             // usa imediato
        reg_dst   = 0;             // escreve em rt
        reg_write = 1;
        mem_to_reg = 0;
        mem_read  = 0;
        mem_write = 0;
        branch    = 0;
        jump      = 0;
        alu_op    = 2'b11;         // novo valor que indicará operação SLTIU na ula_ctrl
      end

      default: begin
        // Instruções não implementadas
      end
    endcase
  end
endmodule
