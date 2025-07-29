module PC(
  input clock,          // Sinal de Clock
  input reset,          // Reset Assíncrono
  input [31:0] nextPC,  // Próximo Endereço
  output reg [31:0] PC  // Endereço Atual
);

  always @(posedge clock or posedge reset) begin
    if (reset)  PC <= 32'h00000000;      // Reset para 0
    else        PC <= nextPC;            // Atualiza na borda de Subida
  end
endmodule
