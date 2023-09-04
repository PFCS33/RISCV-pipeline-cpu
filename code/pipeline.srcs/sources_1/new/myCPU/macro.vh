// constant definition

/* -------------------------------------------------------------------------- */
// bit width
`define BIT_WIDTH 31:0
// initial values
`define ZERO_32 32'h00000000

/* instruction -------------------------------------------------------------------------- */
// opcode
`define OPCODE_R    7'b0110011
`define OPCODE_I    7'b0010011
`define OPCODE_S    7'b0100011
`define OPCODE_B    7'b1100011
`define OPCODE_UJ   7'b1101111

// special opcode
`define OPCODE_JALR 7'b1100111  
`define OPCODE_LW   7'b0000011
`define OPCODE_LUI  7'b0110111

// funct3
`define FUNC3_ADD      3'b000
`define FUNC3_SUB      3'b000  
`define FUNC3_ADDI     3'b000
`define FUNC3_SLL      3'b001
`define FUNC3_SLLI     3'b001  
`define FUNC3_SRA      3'b101
`define FUNC3_SRL      3'b101  
`define FUNC3_SRLI     3'b101  
`define FUNC3_SRAI     3'b101  
`define FUNC3_SLT      3'b010
`define FUNC3_SLTI     3'b010  
`define FUNC3_SLTU     3'b011
`define FUNC3_SLTIU    3'b011  
`define FUNC3_OR       3'b110
`define FUNC3_ORI      3'b110  
`define FUNC3_AND      3'b111
`define FUNC3_ANDI     3'b111  
`define FUNC3_XOR      3'b100
`define FUNC3_XORI     3'b100  
`define FUNC3_JALR     3'b000
`define FUNC3_BNE      3'b001
`define FUNC3_BEQ      3'b000
`define FUNC3_BLT      3'b100
`define FUNC3_BGE      3'b101
`define FUNC3_BLTU     3'b110
`define FUNC3_BGEU     3'b111
`define FUNC3_LW       3'b010
`define FUNC3_SW       3'b010  

// funct7
`define FUNC7_ADD      7'b0000000
`define FUNC7_SUB      7'b0100000
`define FUNC7_SRA      7'b0100000
`define FUNC7_SRL      7'b0000000

// (actually, SLL, SLT, SLTU, OR, AND, XOR don't need a separate FUNCT7 (0000000)
`define FUNC7_SLL   7'b0000000
`define FUNC7_SLT   7'b0000000
`define FUNC7_SLTU  7'b0000000
`define FUNC7_OR    7'b0000000
`define FUNC7_AND   7'b0000000
`define FUNC7_XOR   7'b0000000

// For I-type shifts
`define FUNC7_SLLI     7'b0000000
`define FUNC7_SRAI     7'b0100000
`define FUNC7_SRLI     7'b0000000


/* control -------------------------------------------------------------------------- */
// alu 第2个操作数来源
`define ALU_SRC_REG 1'b0
`define ALU_SRC_IMM 1'b1
// reg 写回数据来源
`define REG_SRC_ALU 1'b0
`define REG_SRC_DMEM 1'b1
// alu 不同的operator
`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_SLL 4'b0010
`define ALU_SRL 4'b0011
`define ALU_SRA 4'b0100
`define ALU_SLT 4'b0101
`define ALU_SLTU 4'b0110
`define ALU_AND 4'b0111
`define ALU_OR 4'b1000
`define ALU_XOR 4'b1001
`define ALU_NOP  4'b1010
// cu 内部的辅助信号
`define OP_TYPE_R 2'b10
`define OP_TYPE_I 2'b11
`define OP_TYPE_B 2'b00
`define OP_TYPE_SL 2'b01
