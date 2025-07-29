// ---------------------------------------------
// OPCODES (MIPS: 6 bits)
// ---------------------------------------------
`define OP_RTYPE  6'b000000
`define OP_ADDI   6'b001000
`define OP_ANDI   6'b001100
`define OP_ORI    6'b001101
`define OP_XORI   6'b001110
`define OP_LW     6'b100011
`define OP_SW     6'b101011
`define OP_BEQ    6'b000100
`define OP_BNE    6'b000101
`define OP_J      6'b000010
`define OP_JAL    6'b000011

// ---------------------------------------------
// FUNCTS (para formato R: 6 bits)
// ---------------------------------------------
`define FUNCT_ADD   6'b100000
`define FUNCT_SUB   6'b100010
`define FUNCT_AND   6'b100100
`define FUNCT_OR    6'b100101
`define FUNCT_XOR   6'b100110
`define FUNCT_NOR   6'b100111
`define FUNCT_SLT   6'b101010
`define FUNCT_SLL   6'b000000
`define FUNCT_SRL   6'b000010
`define FUNCT_SRA   6'b000011
`define FUNCT_JR    6'b001000

// ---------------------------------------------
// OPERAÇÕES DA ULA (sinal OP: 4 bits)
// ---------------------------------------------
`define ALU_ADD   4'b0000
`define ALU_SUB   4'b0001
`define ALU_AND   4'b0010
`define ALU_OR    4'b0011
`define ALU_XOR   4'b0100
`define ALU_NOR   4'b0101
`define ALU_SLT   4'b0110
`define ALU_SLL   4'b1000
`define ALU_SRL   4'b1001
`define ALU_SRA   4'b1010
`define ALU_JR    4'b1110
