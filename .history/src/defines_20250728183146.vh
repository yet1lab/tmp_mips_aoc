// === ALU Operation Codes (4 bits) ===
`define ALU_ADD    4'b0000
`define ALU_SUB    4'b0001
`define ALU_AND    4'b0010
`define ALU_OR     4'b0011
`define ALU_XOR    4'b0100
`define ALU_NOR    4'b0101
`define ALU_SLT    4'b0110
`define ALU_SLTU   4'b0111
`define ALU_SLL    4'b1000
`define ALU_SRL    4'b1001
`define ALU_SRA    4'b1010
`define ALU_SLLV   4'b1011
`define ALU_SRLV   4'b1100
`define ALU_SRAV   4'b1101
`define ALU_JR     4'b1110

// === MIPS OPCODES (6 bits) ===
`define OPCODE_RTYPE  6'b000000  // Tipo R
`define OPCODE_LW     6'b100011  // Load Word
`define OPCODE_SW     6'b101011  // Store Word
`define OPCODE_BEQ    6'b000100  // Branch if Equal
`define OPCODE_BNE    6'b000101  // Branch if Not Equal
`define OPCODE_ADDI   6'b001000  // Add Immediate
`define OPCODE_ANDI   6'b001100  // AND Immediate
`define OPCODE_ORI    6'b001101  // OR Immediate
`define OPCODE_XORI   6'b001110  // XOR Immediate
`define OPCODE_LUI    6'b001111  // Load Upper Immediate
`define OPCODE_SLTI   6'b001010  // Set Less Than Immediate
`define OPCODE_J      6'b000010  // Jump
`define OPCODE_JAL    6'b000011  // Jump and Link

// === Funct Codes para instruções tipo R (6 bits) ===
`define FUNCT_ADD   6'b100000
`define FUNCT_SUB   6'b100010
`define FUNCT_AND   6'b100100
`define FUNCT_OR    6'b100101
`define FUNCT_XOR   6'b100110
`define FUNCT_NOR   6'b100111
`define FUNCT_SLT   6'b101010
`define FUNCT_SLTU  6'b101011
`define FUNCT_SLL   6'b000000
`define FUNCT_SRL   6'b000010
`define FUNCT_SRA   6'b000011
`define FUNCT_SLLV  6'b000100
`define FUNCT_SRLV  6'b000110
`define FUNCT_SRAV  6'b000111
`define FUNCT_JR    6'b001000
