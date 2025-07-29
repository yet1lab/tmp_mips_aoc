`include "src/defines.vh"  // Inclui os defines com os códigos da ULA

module ula( 
  input [31:0] In1,      // Operando 1 (rs) 
  input [31:0] In2,      // Operando 2 (rt)
  input [4:0] shamt,
  input [3:0]  OP,       // Código da operação (vem da ula_ctrl)
  output reg [31:0] result,  // Resultado
  output wire Zero_Flag       // Flag de zero (declarado como wire)
);
  
  always @(*) begin
    case (OP)
      `ALU_ADD:   result = In1 + In2;
      `ALU_SUB:   result = In1 - In2;
      `ALU_AND:   result = In1 & In2;
      `ALU_OR:    result = In1 | In2;
      `ALU_XOR:   result = In1 ^ In2;
      `ALU_NOR:   result = ~(In1 | In2);
      `ALU_SLT:   result = ($signed(In1) < $signed(In2)) ? 1 : 0;
      `ALU_SLTU:  result = (In1 < In2) ? 1 : 0;
      `ALU_SLL:   result = In2 << In1[4:0];        
      `ALU_SRL:   result = In2 >> In1[4:0];         
      `ALU_SRA:   result = $signed(In2) >>> In1[4:0]; 
      `ALU_SLLV:  result = In2 << In1[4:0];       
      `ALU_SRLV:  result = In2 >> In1[4:0];       
      `ALU_SRAV:  result = $signed(In2) >>> In1[4:0]; 
      `ALU_JR:    result = In1;
      default:    result = 0;
    endcase
  end
  
  assign Zero_Flag = (result == 0);
endmodule
