`include "ula_opcodes.vh"

module ula(
  input [31:0] In1,
  input [31:0] In2,
  input [3:0] OP,
  output reg [31:0] result,
  output wire Zero_Flag
);

  always @(*) begin
    case (OP)
      `ADD:   result = In1 + In2;
      `SUB:   result = In1 - In2;
      `AND:   result = In1 & In2;
      `OR:    result = In1 | In2;
      `XOR:   result = In1 ^ In2;
      `NOR:   result = ~(In1 | In2);
      `SLT:   result = ($signed(In1) < $signed(In2)) ? 1 : 0;
      `SLTU:  result = (In1 < In2) ? 1 : 0;
      `SLL:   result = In2 << In1[4:0];
      `SRL:   result = In2 >> In1[4:0];
      `SRA:   result = $signed(In2) >>> In1[4:0];
      `SLLV:  result = In2 << In1[4:0];
      `SRLV:  result = In2 >> In1[4:0];
      `SRAV:  result = $signed(In2) >>> In1[4:0];
      `JR:    result = In1;
      default: result = 0;
    endcase
  end

  assign Zero_Flag = (result == 0);
endmodule
