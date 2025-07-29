/*[opcode] [ rs ] [ rt ] [ rd ] [shamt] [funct]
   31-26   25-21  20-16  15-11    10-6   5-0   */

module mips(
  input clock,
  input reset,
  output [31:0] PCOut,
  output [31:0] ALUResultOut,
  output [31:0] MemOut
);
  // Conexões principais
  wire [31:0] PC, nextPC, instruction;
  wire [31:0] read_data1, read_data2, write_data;
  wire [31:0] sign_ext_out, alu_in2, dmem_out;
  wire [4:0] shamt = instruction[10:6];
  
  // Sinais de controle expandidos
  wire RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Jr, ExtOp, JalEn, LuiEn;
  wire [1:0] ALUOp;
  
  // Instância dos módulos principais
  PC pc(clock, reset, nextPC, PC);
  assign PCOut = PC;  // Saída do PC para depuração
  
  i_mem imem(PC, instruction);
  
  // Lógica de seleção de registrador de escrita
  wire [4:0] write_reg = 
    JalEn ? 5'b11111 :                    // JAL usa $ra (reg 31)
    (RegDst ? instruction[15:11] : instruction[20:16]); // Padrão
  
  // Banco de registradores
  regfile regs(
    .clock(clock),
    .reset(reset),
    .RegWrite(RegWrite),
    .ReadAddr1(instruction[25:21]),  // rs
    .ReadAddr2(instruction[20:16]),  // rt
    .WriteAddr(write_reg),
    .WriteData(write_data),
    .ReadData1(read_data1),
    .ReadData2(read_data2)
  );
  
  // Extensão de sinal
  sign_extend ext(
    .imm(instruction[15:0]),
    .ExtOp(ExtOp),
    .ext_out(sign_ext_out)
  );
  
  // Seleção de entrada da ULA
  assign alu_in2 = ALUSrc ? sign_ext_out : read_data2;
  
  // Controle da ULA
  wire [3:0] alu_control;
  ula_ctrl uctrl(
    .ALUOp(ALUOp),
    .funct(instruction[5:0]),
    .OP_ula(alu_control)
  );
  
  // Unidade Lógica-Aritmética
  wire zero_flag;
  ula alu(
    .shamt(shamt),
    .In1(read_data1),
    .In2(alu_in2),
    .OP(alu_control),
    .result(ALUResultOut),
    .Zero_Flag(zero_flag)
  );
  
  // Memória de dados
  d_mem dmem(
    .clock(clock),
    .address(ALUResultOut),
    .WriteData(read_data2),
    .ReadData(dmem_out),
    .MemWrite(MemWrite),
    .MemRead(MemRead)
  );
  assign MemOut = dmem_out;  // Saída de memória para depuração
  
  // Cálculos de PC
  wire [31:0] pc_plus4 = PC + 4;
  wire [31:0] branch_offset = {sign_ext_out[29:0], 2'b00};
  wire [31:0] branch_target = pc_plus4 + branch_offset;
  wire is_jr = !(|instruction[31:26]) && (instruction[5:0] == 6'b001000);  // JR (opcode=0, funct=8)
  
  // Lógica de branch
  wire branch_taken = Branch & 
                     ((instruction[31:26] == 6'b000100 & zero_flag) |  // BEQ zero
                      (instruction[31:26] == 6'b000101 & ~zero_flag)); // BNE não-zero
  
  // Seleção do próximo PC
  assign nextPC = 
    is_jr     ? read_data1 :                     // JR prioridade máxima
    Jump      ? {pc_plus4[31:28], instruction[25:0], 2'b00} : // Jump/JAL
    branch_taken ? branch_target :                // Branch
    pc_plus4;                                   // Sequencial

  // Seleção de dados para escrita no registrador
  assign write_data = 
    JalEn ? pc_plus4 :                     // JAL: escreve PC+4
    LuiEn ? {instruction[15:0], 16'b0} :   // LUI: {imm, 0}
    MemtoReg ? dmem_out :                  // LW: dado da memória
    ALUResultOut;                          // Padrão: resultado ULA

  // Unidade de controle
  control ctrl(
    .opcode(instruction[31:26]),
    .RegDst(RegDst),
    .Jump(Jump),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .Jr(Jr),
    .ExtOp(ExtOp),
    .JalEn(JalEn),
    .LuiEn(LuiEn)
  );

endmodule