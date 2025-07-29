`include "src/defines.vh"

module ula_ctrl(
  input [1:0] ALUOp,
  input [5:0] funct,
  output reg [3:0] OP_ula
);

  always @(*) begin
    case (ALUOp)
      2'b00: OP_ula = `MIPS_ADD;       // lw/sw/addi
      2'b01: OP_ula = `MIPS_SUB;       // beq/bne
      2'b10: begin                   // R-type
        case (funct)
          `FUNCT_ADD:   OP_ula = `MIPS_ADD;
          `FUNCT_SUB:   OP_ula = `MIPS_SUB;
          `FUNCT_AND:   OP_ula = `MIPS_AND;
          `FUNCT_OR:    OP_ula = `MIPS_OR;
          `FUNCT_XOR:   OP_ula = `MIPS_XOR;
          `FUNCT_NOR:   OP_ula = `MIPS_NOR;
          `FUNCT_SLT:   OP_ula = `MIPS_SLT;
          `FUNCT_SLTU:  OP_ula = `MIPS_SLTU;
          `FUNCT_SLL:   OP_ula = `MIPS_SLL;
          `FUNCT_SRL:   OP_ula = `MIPS_SRL;
          `FUNCT_SRA:   OP_ula = `MIPS_SRA;
          `FUNCT_SLLV:  OP_ula = `MIPS_SLLV;
          `FUNCT_SRLV:  OP_ula = `MIPS_SRLV;
          `FUNCT_SRAV:  OP_ula = `MIPS_SRAV;
          `FUNCT_JR:    OP_ula = `MIPS_JR;
          default:      OP_ula = `MIPS_ADD;
        endcase
      end
      default: OP_ula = `MIPS_ADD;
    endcase
  end
endmodule
