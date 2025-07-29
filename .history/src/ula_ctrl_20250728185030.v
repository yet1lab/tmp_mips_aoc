`include "src/defines.vh"

module ula_ctrl(
  input [1:0] ALUOp,
  input [5:0] funct,
  output reg [3:0] OP_ula
);

  always @(*) begin
    case (ALUOp)
      2'b00: OP_ula = `ALU_ADD;       // ADD (lw/sw/addi)
      2'b01: OP_ula = `ALU_SUB;       // SUB (beq/bne)
      2'b10: begin                  // Instruções tipo-R
        case (funct)
          `FUNCT_ADD:  OP_ula = `ALU_ADD;
          `FUNCT_SUB:  OP_ula = `ALU_SUB;
          `FUNCT_AND:  OP_ula = `ALU_AND;
          `FUNCT_OR:   OP_ula = `ALU_OR;
          `FUNCT_XOR:  OP_ula = `ALU_XOR;
          `FUNCT_NOR:  OP_ula = `ALU_NOR;
          `FUNCT_SLT:  OP_ula = `ALU_SLT;
          `FUNCT_SLTU: OP_ula = `ALU_SLTU;
          `FUNCT_SLL:  OP_ula = `ALU_SLL;
          `FUNCT_SRL:  OP_ula = `ALU_SRL;
          `FUNCT_SRA:  OP_ula = `ALU_SRA;
          `FUNCT_SLLV: OP_ula = `ALU_SLLV;
          `FUNCT_SRLV: OP_ula = `ALU_SRLV;
          `FUNCT_SRAV: OP_ula = `ALU_SRAV;
          `FUNCT_JR:   OP_ula = `ALU_JR;
          default:     OP_ula = `ALU_ADD;
        endcase
      end
      default: OP_ula = `ALU_ADD;
    endcase
  end

endmodule
