`include "src/defines.vh"

module ula_ctrl(
  input [1:0] ALUOp,
  input [5:0] funct,
  output reg [3:0] OP_ula
);

  always @(*) begin
    case (ALUOp)
      2'b00: OP_ula = `OP_ADD;       // lw/sw/addi
      2'b01: OP_ula = `OP_SUB;       // beq/bne
      2'b10: begin                   // R-type
        case (funct)
          `FUNCT_ADD:   OP_ula = `OP_ADD;
          `FUNCT_SUB:   OP_ula = `OP_SUB;
          `FUNCT_AND:   OP_ula = `OP_AND;
          `FUNCT_OR:    OP_ula = `OP_OR;
          `FUNCT_XOR:   OP_ula = `OP_XOR;
          `FUNCT_NOR:   OP_ula = `OP_NOR;
          `FUNCT_SLT:   OP_ula = `OP_SLT;
          `FUNCT_SLTU:  OP_ula = `OP_SLTU;
          `FUNCT_SLL:   OP_ula = `OP_SLL;
          `FUNCT_SRL:   OP_ula = `OP_SRL;
          `FUNCT_SRA:   OP_ula = `OP_SRA;
          `FUNCT_SLLV:  OP_ula = `OP_SLLV;
          `FUNCT_SRLV:  OP_ula = `OP_SRLV;
          `FUNCT_SRAV:  OP_ula = `OP_SRAV;
          `FUNCT_JR:    OP_ula = `OP_JR;
          default:      OP_ula = `OP_ADD;
        endcase
      end
      default: OP_ula = `OP_ADD;
    endcase
  end
endmodule
