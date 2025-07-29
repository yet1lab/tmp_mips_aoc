`include "ula_opcodes.vh"
module ula( 
  input [31:0] In1,      // Operando 1 (rs) 
  input [31:0] In2,      // Operando 2 (rt)
  input [3:0]  OP,       // Código da operação (vem da ula_ctrl)
  output reg [31:0] result,  // Resultado
  output wire Zero_Flag       // Flag de zero (declarado como wire)
);
  
  // códigos de operação
  localparam 
    ADD  = 4'b0000,
    SUB  = 4'b0001,
    AND  = 4'b0010,
    OR   = 4'b0011,
    XOR  = 4'b0100,
    NOR  = 4'b0101,
    SLT  = 4'b0110,
    SLTU = 4'b0111,
    SLL  = 4'b1000,   // Shift Left Logical com shamt
    SRL  = 4'b1001,   // Shift Right Logical com shamt
    SRA  = 4'b1010,   // Shift Right Arithmetic com shamt
    SLLV = 4'b1011,   // Shift Left Logical Variable
    SRLV = 4'b1100,   // Shift Right Logical Variable
    SRAV = 4'b1101,   // Shift Right Arithmetic Variable
    JR   = 4'b1110;   // Jump Register
  
  always @(*) begin
    case (OP)
      ADD:   result = In1 + In2;
      SUB:   result = In1 - In2;
      AND:   result = In1 & In2;
      OR:    result = In1 | In2;
      XOR:   result = In1 ^ In2;
      NOR:   result = ~(In1 | In2);
      SLT:   result = ($signed(In1) < $signed(In2)) ? 1 : 0;
      SLTU:  result = (In1 < In2) ? 1 : 0;
      SLL:   result = In2 << In1[4:0];         // Shamt de In1[4:0]
      SRL:   result = In2 >> In1[4:0];         // Shamt de 5 bits
      SRA:   result = $signed(In2) >>> In1[4:0]; 
      SLLV:  result = In2 << In1[4:0];       
      SRLV:  result = In2 >> In1[4:0];       
      SRAV:  result = $signed(In2) >>> In1[4:0]; 
      JR:    result = In1;
      default: result = 0;
    endcase
  end
  
  assign Zero_Flag = (result == 0);
endmodule