module sign_extend(
  input [15:0] imm,     // Imediato de 16 bits
  input ExtOp,          // 1= ext.signal, 0=ext.zero
  output reg [31:0] ext_out
);
  always @(*) begin
    if (ExtOp)
      ext_out = {{16{imm[15]}}, imm};  // estende sinal
    else
      ext_out = {16'b0, imm};          // estende zero
  end
endmodule