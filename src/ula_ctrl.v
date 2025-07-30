//=========================================
//              ULA CONTROL
//=========================================
`include "src/defines.vh"

module ula_ctrl(
  input [1:0] ALUOp,
  input [5:0] funct,
  output reg [3:0] OP_ula
);
  always @(*) begin
    case (ALUOp)
      2'b00: OP_ula = `ALU_ADD;     // ADD (lw/sw/addi)
      2'b01: OP_ula = `ALU_SUB;     // SUB (beq/bne)
      2'b10: begin                  // Instruções tipo-R
        case (funct)
          `FUNCT_ADD:  OP_ula = `ALU_ADD;  // R.1
          `FUNCT_SUB:  OP_ula = `ALU_SUB;  // R.2
          `FUNCT_AND:  OP_ula = `ALU_AND;  // R.3
          `FUNCT_OR:   OP_ula = `ALU_OR;   // R.4
          `FUNCT_XOR:  OP_ula = `ALU_XOR;  // R.5
          `FUNCT_NOR:  OP_ula = `ALU_NOR;  // R.6
          `FUNCT_SLT:  OP_ula = `ALU_SLT;  // R.7
          `FUNCT_SLTU: OP_ula = `ALU_SLTU; // R.8
          `FUNCT_SLL:  OP_ula = `ALU_SLL;  // R.9
          `FUNCT_SRL:  OP_ula = `ALU_SRL;  // R.10
          `FUNCT_SRA:  OP_ula = `ALU_SRA;  // R.11
          `FUNCT_SLLV: OP_ula = `ALU_SLLV; // R.12
          `FUNCT_SRLV: OP_ula = `ALU_SRLV; // R.13
          `FUNCT_SRAV: OP_ula = `ALU_SRAV; // R.14
          `FUNCT_JR:   OP_ula = `ALU_JR;   // R.15
          default:     OP_ula = `ALU_ADD;
        endcase
      end
      default: OP_ula = `ALU_ADD;
    endcase
  end
endmodule
