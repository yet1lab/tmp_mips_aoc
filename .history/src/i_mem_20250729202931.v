`include "src/defines.vh"

module i_mem(
  input  wire [31:0] address,   // instruction address
  output wire [31:0] i_out      // 32 bits instruction
);
  reg [31:0] mem [0:`IMEM_SIZE-1];
  initial begin
    $readmemb("sim/mem.list", mem);  // load external file
  end
  
  assign i_out = mem[address[11:2]]; // address by bytes, but instructions uses 32 bits (4 bytes) 
endmodule
