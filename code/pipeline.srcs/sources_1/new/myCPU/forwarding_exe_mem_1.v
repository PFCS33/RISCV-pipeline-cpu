`timescale 1ns / 1ps
`include "macro.vh"

// solving "WAR", forward rs1 & rs2 to the exe stage
module forward_exe_mem_1(
    // exe阶段的reg_src 有可能被 exe_mem / mem_wb forward
    input exe_mem_reg_we,
    input[4:0] exe_mem_rd, // from exe_mem_inst

    input mem_wb_reg_we,
    input[4:0] mem_wb_rd,  // from mem_wb_inst

    input [4:0] id_exe_rs1, id_exe_rs2, // from id_exe_inst
    input [6:0] id_exe_opcode,  

    // 3种情况，故2位
    output reg[1:0] forward_in1, forward_in2

);

always@(*) begin
        // UJ型，不进行forward
    if (id_exe_opcode == `OPCODE_UJ) begin
        forward_in1 = 2'b00;
        forward_in2 = 2'b00;
    end
    else
    begin
        // in1
        if (exe_mem_reg_we && exe_mem_rd != 5'b0 && exe_mem_rd == id_exe_rs1) 
        begin 
            forward_in1 = 2'b10;
        end
        else if (mem_wb_reg_we && mem_wb_rd != 5'b0 && mem_wb_rd == id_exe_rs1) 
            // mem_wb 的forward 优先级更低
        begin
            forward_in1 = 2'b01;
        end
        else 
            forward_in1 = 2'b00;
        // in2
        if (exe_mem_reg_we && exe_mem_rd != 5'b0 && exe_mem_rd == id_exe_rs2) 
        begin
            forward_in2 = 2'b10;
        end
        else if (mem_wb_reg_we && mem_wb_rd != 5'b0 && mem_wb_rd == id_exe_rs2) 
        begin
            forward_in2 = 2'b01;
        end
        else 
            forward_in2 = 2'b00;
    end

end


endmodule