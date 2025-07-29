//=========================================
//             MEMORY PARAMETERS
//=========================================
`define IMEM_SIZE 1024  // Para instruções tipo-R
`define DMEM_SIZE 1024  // Para instruções tipo-R

//=========================================
//             ALUOp CODES (2 bits)
//=========================================
`define ALUOP_RTYPE         2'b10  // Para instruções tipo-R
`define ALUOP_BEQ_BNE       2'b01  // Para beq e bne (SUB)
`define ALUOP_LW_SW_ADDI    2'b00  // Para lw, sw e addi (ADD)
`define ALUOP_ANDI_ORI_XORI 2'b11  // Para instruções ANDI, ORI, XORI

//=========================================
// ULA INTERNAL CODES - ARBITRARY (4 bits)
//=========================================
`define ALU_ADD   4'b0010 // R.1
`define ALU_SUB   4'b0011 // R.2

`define ALU_AND   4'b0100 // R.3
`define ALU_OR    4'b0001 // R.4
`define ALU_XOR   4'b0101 // R.5
`define ALU_NOR   4'b0110 // R.6

`define ALU_SLT   4'b0111 // R.7
`define ALU_SLTU  4'b1011 // R.8
`define ALU_SLL   4'b1000 // R.9
`define ALU_SRL   4'b1001 // R.10
`define ALU_SRA   4'b1010 // R.11

`define ALU_SLLV  4'b1100 // R.1
`define ALU_SRLV  4'b1101 // R.1
`define ALU_SRAV  4'b1110 // R.1

`define ALU_JR    4'b0000 // R.1

//=========================================
//        FUNCT FOR R-TYPE (6 bits)
//=========================================
`define FUNCT_ADD   6'b100000 // R.1 
`define FUNCT_SUB   6'b100010 // R.2 

`define FUNCT_AND   6'b100100 // R.3 
`define FUNCT_OR    6'b100101 // R.4 
`define FUNCT_XOR   6'b100110 // R.5 
`define FUNCT_NOR   6'b100111 // R.6 

`define FUNCT_SLT   6'b101010 // R.7
`define FUNCT_SLTU  6'b101011 // R.8 
`define FUNCT_SLL   6'b000000 // R.9 
`define FUNCT_SRL   6'b000010 // R.10 
`define FUNCT_SRA   6'b000011 // R.11 

`define FUNCT_SLLV  6'b000100 // R.12 
`define FUNCT_SRLV  6'b000110 // R.13 
`define FUNCT_SRAV  6'b000111 // R.14 

`define FUNCT_JR    6'b001000 // R.15 

//=========================================
//          MIPS OPCODES (6 bits)
//=========================================
`define MIPS_RTYPE  6'b000000  // Tipo R

`define MIPS_ADDI   6'b001000  // I.1
`define MIPS_ANDI   6'b001100  // I.2
`define MIPS_ORI    6'b001101  // I.3
`define MIPS_XORI   6'b001110  // I.4

`define MIPS_BEQ    6'b000100  // I.5
`define MIPS_BNE    6'b000101  // I.6
`define MIPS_SLTI   6'b001010  // I.7
`define MIPS_SLTIU  6'b001011  // I.8
`define MIPS_LUI    6'b001111  // I.9

`define MIPS_LW     6'b100011  // I.10
`define MIPS_SW     6'b101011  // I.11
//=========================================
`define MIPS_J      6'b000010  // J.1
`define MIPS_JAL    6'b000011  // J.2
