`timescale 1ns/1ps

module test;

  // Sinais de clock e reset
  reg clk;
  reg reset;

  // Saídas de debug (opcional)
  wire [31:0] pc;
  wire [31:0] instr;

  // Clock: alterna a cada 5ns
  always #5 clk = ~clk;

  // Instancia seu processador (substitua "MIPS" pelo nome do seu top-level)
  MIPS dut (
    .clock(clk),
    .reset(reset),
    .PC(pc),
    .instruction(instr)
    // outros sinais, se houver
  );

  initial begin
    // Configura dump de onda
    $dumpfile("sim/wav.vcd");
    $dumpvars(0, test);  // 'test' é o nome do módulo de testbench

    // Inicializa sinais
    clk = 0;
    reset = 1;
    #10 reset = 0; // Reset em 10ns

    // Simula por 1000ns, depois encerra
    #1000;
    $finish;
  end

endmodule
