`timescale 1ns / 1ps
`include "macro.vh"

module nop_detect(
    input clk,
    input id_exe_dmem_read,
    input [4:0]  if_id_rs1, if_id_rs2, id_ex_rd,
    input [6:0] if_id_opcode, id_exe_opcode, exe_mem_opcode,

    // we: stall，停止取下条指令
    output reg pc_we, if_id_we,
    // empty: 产生 nop指令
    output reg if_id_empty, id_exe_empty
);

always@(negedge clk) begin
    // load_use hazard
    if(if_id_opcode != `OPCODE_S && id_exe_dmem_read &&  (id_ex_rd == if_id_rs1 || id_ex_rd == if_id_rs1) )
    begin
        // 停顿store指令，情空 id_exe，在中间产生一个nop
        pc_we <= 0;
        if_id_we <= 0;
        id_exe_empty <= 1;
    end
    // control hazard (branch/jar/jalr)
     else if (if_id_opcode == `OPCODE_B || id_exe_opcode == `OPCODE_B || exe_mem_opcode == `OPCODE_B
                || if_id_opcode == `OPCODE_UJ || id_exe_opcode == `OPCODE_UJ || exe_mem_opcode == `OPCODE_UJ
                || if_id_opcode == `OPCODE_JALR || id_exe_opcode == `OPCODE_JALR || exe_mem_opcode == `OPCODE_JALR) 
            begin
            // 插入三条空指令
            if (if_id_opcode == `OPCODE_B || if_id_opcode == `OPCODE_UJ || if_id_opcode == `OPCODE_JALR) 
            begin
                pc_we <= 0;
                if_id_empty <= 1;
                id_exe_empty <= 0;
            end
            if (id_exe_opcode == `OPCODE_B || id_exe_opcode == `OPCODE_UJ || id_exe_opcode == `OPCODE_JALR) 
            begin
                pc_we <= 0;
                if_id_empty <= 1;
                id_exe_empty <= 0;
            end
            if (exe_mem_opcode == `OPCODE_B || exe_mem_opcode == `OPCODE_UJ || exe_mem_opcode == `OPCODE_JALR) 
            begin
                // MEM阶段获得新的PC值，将pc_we置位  
                pc_we <= 1;
                if_id_empty <= 1;
                id_exe_empty <= 0;
            end
        end
    // reset
    else begin
        pc_we <= 1'b1;
        if_id_we <= 1'b1;
        if_id_empty <= 1'b0;
        id_exe_empty <= 1'b0;
    end

end

endmodule