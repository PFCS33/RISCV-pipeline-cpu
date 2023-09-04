`timescale 1ns / 1ps
`include "macro.vh"

module imm_gen(
    input [`BIT_WIDTH] inst,  
    output reg [`BIT_WIDTH] imm
);

// 符号拓展
always@(*) begin
    // I (including lw & jalr)
    if (inst[6:0] == `OPCODE_I || inst[6:0] == `OPCODE_LW || inst[6:0] == `OPCODE_JALR)
    begin
        if (inst[14:12] == `FUNC3_SLLI || inst[14:12] == `FUNC3_SRLI || inst[14:12] == `FUNC3_SRAI)
            imm = {{27{inst[24]}} ,inst[24:20]};
        else 
        begin
            imm = {{20{inst[31]}} ,inst[31:20]};
        end
    end
    // S
    else if (inst[6:0] == `OPCODE_S) 
    begin
        imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
    end
    // B
    else if (inst[6:0] == `OPCODE_B) 
    begin
        imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
    end
    // LUI
    else if(inst[6:0] == `OPCODE_LUI)
        imm = {inst[31:12], 12'b0};
    // UJ
    else if (inst[6:0] == `OPCODE_UJ) begin
        imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
    end
    else begin
        imm = 0;
    end
end



endmodule
