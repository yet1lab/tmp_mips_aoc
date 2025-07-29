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
      // Instruções tipo-R (inclui JR)
      6'b000000: begin
        RegDst   = 1;
        RegWrite = 1;
        ALUOp    = 2'b10;
      end

      // LW
      6'b100011: begin
        ALUSrc   = 1;
        MemtoReg = 1;
        RegWrite = 1;
        MemRead  = 1;
      end

      // SW
      6'b101011: begin
        ALUSrc   = 1;
        MemWrite = 1;
      end

      // BEQ
      6'b000100: begin
        Branch = 1;
        ALUOp  = 2'b01; // Subtração
      end

      // BNE
      6'b000101: begin
        Branch = 1;
        ALUOp  = 2'b01; // Subtração
      end

      // ADDI
      6'b001000: begin
        ALUSrc   = 1;
        RegWrite = 1;
      end

      // ANDI
      6'b001100: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0; // Extensão por zero
        ALUOp    = 2'b11; // Força operação AND
      end

      // ORI
      6'b001101: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0; // Extensão por zero
        ALUOp    = 2'b11; // Força operação OR
      end

      // XORI
      6'b001110: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0; // Extensão por zero
        ALUOp    = 2'b11; // Força operação XOR
      end

      // J
      6'b000010: begin
        Jump = 1;
      end

      // JAL
      6'b000011: begin
        Jump     = 1;
        RegWrite = 1;
        JalEn    = 1; // Sinal especial       
      end

      // LUI
      6'b001111: begin
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