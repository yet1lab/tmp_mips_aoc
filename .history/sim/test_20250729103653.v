`timescale 1ns/1ps

module test;
  reg clk;
  reg reset;
  
  wire [31:0] pc;       // debug output
  wire [31:0] instr;    // debug output
  always #5 clk = ~clk; // alternate clock for each 5ns
  
  mips dut (            // create mips with top-level
    .clock(clk),
    .reset(reset)
  );

  initial begin
    $dumpfile("sim/wav.vcd"); // waveform out
    $dumpvars(0, test);       // testbench name
    
    clk = 0;       // start signal
    reset = 1;     // start signal
    #10 reset = 0; // Reset in 10ns
    
    #10000;      // emulate for 1000ns
    $finish;    // and stop
  end

endmodule
