initial begin
    $dumpfile("sim/wav.vcd");      // Caminho para o arquivo de ondas
    $dumpvars(0, DUT);             // Onde DUT é o nome do seu módulo top-level (por exemplo: top, mips, cpu, etc)
end