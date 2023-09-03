`timescale 1ns / 1ps
`include "macro.vh"

// forward rs1 & rs2 to the id stage, for reading data from register file
module forwarding_mem_wb_2(
    input mem_wb_reg_we,
    input [4:0] mem_wb_rd, // from mem_wb_inst
    input [4:0] if_id_rs1, if_id_rs2, // from if_id_isnt

    output reg forward_rd1, forward_rd2 // 为1时，代表会被forward
);

always@(*) begin
    // 前提：之前的指令的寄存器写使能置1，且目的寄存器地址不为0
    if (mem_wb_reg_we && mem_wb_rd != 0) 
    begin
        if (mem_wb_rd == if_id_rs1) 
            forward_rd1 = 1'b1;
        else 
            forward_rd1 = 1'b0;
        if (mem_wb_rd == if_id_rs2) 
            forward_rd2 = 1'b1;
        else 
            forward_rd2 = 1'b0;
    end
    else begin
        forward_rd1 = 1'b0;
        forward_rd2 = 1'b0;
    end
end

endmodule