/*[opcode] [ rs ] [ rt ] [ rd ] [shamt] [funct]
   31-26   25-21  20-16  15-11    10-6   5-0   */




module PC(
  input clock,          // Sinal de Clock
  input reset,          // Reset Assíncrono
  input [31:0] nextPC,  // Próximo Endereço
  output reg [31:0] PC  // Endereço Atual
);
  
  always @(posedge clock or posedge reset) begin
    if (reset)  PC <= 32'h00000000;      // Reset para 0
    else        PC <= nextPC;           // Atualiza na borda de Subida
  end
endmodule



  


module i_mem(
  input [31:0] address,    // Endereço da instrução
  output reg [31:0] i_out  // Instrução lida
);
  
  // Memória ROM com 1024 posições (1Kb)
  reg [31:0] mem [0:1023];
  
  // Inicializa com instruções do arquivo
  initial begin
    $readmemb("instruction.list", mem);
  end
  
  // Leitura assíncrona (sem clock)
  always @(*) begin
    i_out = mem[address[11:2]];    // Divide por 4 (endereçamento word-aligned)
  end
endmodule







module regfile(
  input clock,
  input reset,
  input RegWrite,        // Habilita escrita
  input [4:0] ReadAddr1,     // Endereço rs (Register Source)
  input [4:0] ReadAddr2,     // Endereço rt (Register Target)
  input [4:0] WriteAddr,     // Endereço rd (Register Destination/Tipo R)
  input [31:0] WriteData,    // Dado a Escrever
  output [31:0] ReadData1,   // Valor de rs
  output [31:0] ReadData2    // Valor de rt             
);
    
    reg [31:0] registers [0:31];  // 32 Registradores

  // Leitura assíncrona
  assign ReadData1 = (ReadAddr1 == 0) ? 0 : registers[ReadAddr1];
  assign ReadData2 = (ReadAddr2 == 0) ? 0 : registers[ReadAddr2];
    
  // Escrita síncrona (reset asspincrono)
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      for (integer i = 0; i < 32; i++)
        registers[i] <= 0;        // Zera todos os registradores
    end
    else if (RegWrite && WriteAddr != 0) begin
      registers[WriteAddr] <= WriteData;  // Escreve em rd (exceto $zero)
    end
  end
endmodule





    
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





    
module ula( 
  input [31:0] In1,      // Operando 1 (rs) 
  input [31:0] In2,      // Operando 2 (rt)
  input [3:0]  OP,       // Código da operação (vem da ula_ctrl)
  output reg [31:0] result,  // Resultado
  output wire Zero_Flag       // Flag de zero (declarado como wire)
);
  
  // códigos de operação
  localparam 
    ADD  = 4'b0000,
    SUB  = 4'b0001,
    AND  = 4'b0010,
    OR   = 4'b0011,
    XOR  = 4'b0100,
    NOR  = 4'b0101,
    SLT  = 4'b0110,
    SLTU = 4'b0111,
    SLL  = 4'b1000,   // Shift Left Logical com shamt
    SRL  = 4'b1001,   // Shift Right Logical com shamt
    SRA  = 4'b1010,   // Shift Right Arithmetic com shamt
    SLLV = 4'b1011,   // Shift Left Logical Variable
    SRLV = 4'b1100,   // Shift Right Logical Variable
    SRAV = 4'b1101,   // Shift Right Arithmetic Variable
    JR   = 4'b1110;   // Jump Register
  
  always @(*) begin
    case (OP)
      ADD:   result = In1 + In2;
      SUB:   result = In1 - In2;
      AND:   result = In1 & In2;
      OR:    result = In1 | In2;
      XOR:   result = In1 ^ In2;
      NOR:   result = ~(In1 | In2);
      SLT:   result = ($signed(In1) < $signed(In2)) ? 1 : 0;
      SLTU:  result = (In1 < In2) ? 1 : 0;
      SLL:   result = In2 << In1[4:0];         // Shamt de In1[4:0]
      SRL:   result = In2 >> In1[4:0];         // Shamt de 5 bits
      SRA:   result = $signed(In2) >>> In1[4:0]; 
      SLLV:  result = In2 << In1[4:0];       
      SRLV:  result = In2 >> In1[4:0];       
      SRAV:  result = $signed(In2) >>> In1[4:0]; 
      JR:    result = In1;
      default: result = 0;
    endcase
  end
  
  assign Zero_Flag = (result == 0);
endmodule






module ula_ctrl(
  input [1:0] ALUOp,
  input [5:0] funct,
  output reg [3:0] OP_ula
);

  always @(*) begin
    case (ALUOp)
      2'b00: OP_ula = 4'b0000;       // ADD (lw/sw/addi)
      2'b01: OP_ula = 4'b0001;       // SUB (beq/bne)
      2'b10: begin                  // Instruções tipo-R
        case (funct)
          6'b100000: OP_ula = 4'b0000;  // ADD
          6'b100010: OP_ula = 4'b0001;  // SUB
          6'b100100: OP_ula = 4'b0010;  // AND
          6'b100101: OP_ula = 4'b0011;  // OR
          6'b100110: OP_ula = 4'b0100;  // XOR
          6'b100111: OP_ula = 4'b0101;  // NOR
          6'b101010: OP_ula = 4'b0110;  // SLT
          6'b101011: OP_ula = 4'b0111;  // SLTU
          6'b000000: OP_ula = 4'b1000;  // SLL
          6'b000010: OP_ula = 4'b1001;  // SRL
          6'b000011: OP_ula = 4'b1010;  // SRA
          6'b000100: OP_ula = 4'b1011;  // SLLV
          6'b000110: OP_ula = 4'b1100;  // SRLV
          6'b000111: OP_ula = 4'b1101;  // SRAV
          6'b001000: OP_ula = 4'b1110;  // JR
          default:   OP_ula = 4'b0000;
        endcase
      end
      default: OP_ula = 4'b0000;
    endcase
  end
endmodule






module control(
  input [5:0] opcode,
  output reg RegDst,
  output reg Jump,
  output reg Branch,
  output reg MemRead,
  output reg MemtoReg,
  output reg [1:0] ALUOp,
  output reg MemWrite,
  output reg ALUSrc,
  output reg RegWrite,
  output reg Jr,           // Sinal para JR
  output reg ExtOp,        // Extensão de sinal
  output reg JalEn,        // Sinal para JAL
  output reg LuiEn         // Sinal para LUI
);

  always @(*) begin
    // Reset de todos os sinais
    RegDst   = 0;
    Jump     = 0;
    Branch   = 0;
    MemRead  = 0;
    MemtoReg = 0;
    ALUOp    = 2'b00;
    MemWrite = 0;
    ALUSrc   = 0;
    RegWrite = 0;
    Jr       = 0;
    ExtOp    = 1;
    JalEn    = 0;
    LuiEn    = 0;

    case (opcode)
      // Instruções tipo-R (inclui JR)
      6'b000000: begin
        RegDst   = 1;
        RegWrite = 1;
        ALUOp    = 2'b10;
      end

      // LW
      6'b100011: begin
        ALUSrc   = 1;
        MemtoReg = 1;
        RegWrite = 1;
        MemRead  = 1;
      end

      // SW
      6'b101011: begin
        ALUSrc   = 1;
        MemWrite = 1;
      end

      // BEQ
      6'b000100: begin
        Branch = 1;
        ALUOp  = 2'b01; // Subtração
      end

      // BNE
      6'b000101: begin
        Branch = 1;
        ALUOp  = 2'b01; // Subtração
      end

      // ADDI
      6'b001000: begin
        ALUSrc   = 1;
        RegWrite = 1;
      end

      // ANDI
      6'b001100: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0; // Extensão por zero
        ALUOp    = 2'b11; // Força operação AND
      end

      // ORI
      6'b001101: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0; // Extensão por zero
        ALUOp    = 2'b11; // Força operação OR
      end

      // XORI
      6'b001110: begin
        ALUSrc   = 1;
        RegWrite = 1;
        ExtOp    = 0; // Extensão por zero
        ALUOp    = 2'b11; // Força operação XOR
      end

      // J
      6'b000010: begin
        Jump = 1;
      end

      // JAL
      6'b000011: begin
        Jump     = 1;
        RegWrite = 1;
        JalEn    = 1; // Sinal especial       
      end

      // LUI
      6'b001111: begin
        ALUSrc   = 1;
        RegWrite = 1;
        LuiEn    = 1; // Sinal especial
      end
      
      default: begin 
        // Instruções não implementadas
      end
    endcase
  end
endmodule





module d_mem(
  input clock,
  input [31:0] address,
  input [31:0] WriteData,
  output [31:0] ReadData,
  input MemWrite,
  input MemRead
);
  
  reg [31:0] mem [0:1023]; // Memória de 1K palavras
  
  assign ReadData = MemRead ? mem[address[11:2]] : 32'bz;
  
  always @(posedge clock) begin
    if (MemWrite)
      mem[address[11:2]] <= WriteData;
  end
endmodule






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