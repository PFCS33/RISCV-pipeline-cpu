`timescale 1ns / 1ps
`include "macro.vh"

module cu(  
    input [`BIT_WIDTH] inst,

    output reg [3:0] alu_op,    // alu 的 op 选择信号
    output reg alu_src, // alu的 src 选择信号
    output reg reg_src, // 寄存器的写数据来源
    output reg reg_we,  // 寄存器写信号
    output reg dmem_we,  // 存储器写信号
    output reg branch,  // 跳转指令判断
    output reg dmem_read   // 标志是否读内存（写后读hazards的判断）

);

reg [2:0] func3;
reg [6:0] func7;
reg [1:0] optype;
always @(*) begin
    func3 = inst[14:12];
    func7 = inst[31:25];
    if (inst[6:0] ==  `OPCODE_R)
        begin
            alu_src=`ALU_SRC_REG;
            reg_src= `REG_SRC_ALU;
            reg_we=1;   
            dmem_we = 0;
            branch = 0;
            dmem_read = 0;
            optype=`OP_TYPE_R;
        end
    else if(inst[6:0] ==`OPCODE_I)
        begin
            alu_src= `ALU_SRC_IMM;
            reg_src= `REG_SRC_ALU;
            reg_we=1;   
            dmem_we = 0;
            branch = 0;
            dmem_read = 0;
            optype=`OP_TYPE_I;
        end
    else if(inst[6:0] == `OPCODE_S )
    begin
        alu_src= `ALU_SRC_IMM;
        reg_src= `REG_SRC_ALU;
        reg_we=0;   
        dmem_we = 1;
        branch = 0;
        dmem_read = 0;
        optype=`OP_TYPE_SL;
        
    end
    else if (inst[6:0] == `OPCODE_LW)
    begin
        alu_src= `ALU_SRC_IMM;
        reg_src= `REG_SRC_DMEM;
        reg_we=1;   
        dmem_we = 0;
        branch = 0;
        dmem_read = 1;
        optype =`OP_TYPE_SL;
        end
    else if (inst[6:0]== `OPCODE_UJ || inst[6:0] ==`OPCODE_JALR)
    begin
        alu_src=`ALU_SRC_IMM;
        reg_src= `REG_SRC_ALU;
        reg_we=1;   
        dmem_we = 0;
        branch = 1;
        dmem_read = 0;
        optype=`OP_TYPE_SL;
    end
    else if ( inst[6:0]==`OPCODE_B)
    begin
        alu_src= `ALU_SRC_REG;
        reg_src= `REG_SRC_ALU;
        reg_we=0;   
        branch = 1;
        dmem_read = 0;
        dmem_we = 0;
        optype=`OP_TYPE_B;
    end
    else
    begin
        alu_src= 0;
        reg_src= 0;
        reg_we=0;   
        branch = 0;
        dmem_read = 0;
        dmem_we = 0;
        optype=2'b00;
    end

    case (optype)
        `OP_TYPE_R: 
        begin
            if(func3 == `FUNC3_ADD && func7==`FUNC7_ADD ) 
                alu_op=`ALU_ADD;
            else if(func3 == `FUNC3_SUB && func7==`FUNC7_SUB ) 
                alu_op = `ALU_SUB;
            else if(func3 == `FUNC3_SLL && func7==`FUNC7_SLL ) 
                alu_op = `ALU_SLL;
            else if(func3 == `FUNC3_SRL&& func7==`FUNC7_SRL ) 
                alu_op = `ALU_SRL;
            else if(func3 == `FUNC3_SRA && func7==`FUNC7_SRA) 
                alu_op = `ALU_SRA;
            else if(func3 == `FUNC3_SLT && func7==`FUNC7_SLT) 
                alu_op = `ALU_SLT;
            else if(func3 == `FUNC3_SLTU && func7==`FUNC7_SLTU ) 
                alu_op = `ALU_SLTU;
            else if(func3 == `FUNC3_SUB && func7==`FUNC7_SUB ) 
                alu_op = `ALU_AND;
            else if(func3 == `FUNC3_AND && func7==`FUNC7_AND ) 
                alu_op = `ALU_OR;
            else if(func3 == `FUNC3_OR && func7==`FUNC7_OR ) 
                alu_op = `ALU_XOR;
            else 
                alu_op=`ALU_NOP;
        end
        `OP_TYPE_I:
        begin
            if(func3 == `FUNC3_ADDI)    
                alu_op= `ALU_ADD;
            else if(func3 == `FUNC3_SLLI && func7 ==`FUNC7_SLLI)
                alu_op= `ALU_SLL;
            else if(func3 == `FUNC3_SRLI && func7 ==`FUNC7_SRLI)
                alu_op= `ALU_SRL;
            else if (func3 == `FUNC3_SRAI & func7 == `FUNC7_SRAI)
                alu_op= `ALU_SRA;
            else if(func3 == `FUNC3_SLTI)
                alu_op= `ALU_SLT;
            else if (func3 == `FUNC3_SLTIU)
                alu_op =`ALU_SLTU;
            else if( func3 ==`FUNC3_ORI)
                alu_op= `ALU_OR;
            else if(func3 ==`FUNC3_ANDI)
                alu_op=`ALU_AND;
            else if(func3 ==`FUNC3_XORI)
                alu_op= `ALU_XOR;
            else    
                alu_op=`ALU_NOP;
        end
        `OP_TYPE_B:
        begin
           alu_op=`ALU_SUB;
        end
        `OP_TYPE_SL:
        begin
            alu_op=`ALU_ADD;
        end
        default: 
        begin
            alu_op=`ALU_NOP;
        end

    endcase
     
end


endmodule