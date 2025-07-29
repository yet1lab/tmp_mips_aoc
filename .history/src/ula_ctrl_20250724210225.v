module ula_ctrl(
  input [1:0] ALUOp,
  input [5:0] funct,
  output reg [3:0] OP_ula
);

  always @(*) begin
    case (ALUOp)
      2'b00: OP_ula = 4'b0000;       // ADD (lw/sw/addi)
      2'b01: OP_ula = 4'b0001;       // SUB (beq/bne)
      2'b10: begin                  // Instruções tipo-R
        case (funct)
          6'b100000: OP_ula = 4'b0000;  // ADD
          6'b100010: OP_ula = 4'b0001;  // SUB
          6'b100100: OP_ula = 4'b0010;  // AND
          6'b100101: OP_ula = 4'b0011;  // OR
          6'b100110: OP_ula = 4'b0100;  // XOR
          6'b100111: OP_ula = 4'b0101;  // NOR
          6'b101010: OP_ula = 4'b0110;  // SLT
          6'b101011: OP_ula = 4'b0111;  // SLTU
          6'b000000: OP_ula = 4'b1000;  // SLL
          6'b000010: OP_ula = 4'b1001;  // SRL
          6'b000011: OP_ula = 4'b1010;  // SRA
          6'b000100: OP_ula = 4'b1011;  // SLLV
          6'b000110: OP_ula = 4'b1100;  // SRLV
          6'b000111: OP_ula = 4'b1101;  // SRAV
          6'b001000: OP_ula = 4'b1110;  // JR
          default:   OP_ula = 4'b0000;
        endcase
      end
      default: OP_ula = 4'b0000;
    endcase
  end
endmodule