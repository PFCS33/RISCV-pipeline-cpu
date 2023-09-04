`timescale 1ns / 1ps


module pipeline_cycle(
    input   wire    rstn,
    input   wire    clk,

    // debug
    output [31:0] debug_reg1,
    output [31:0] debug_reg2,
    output [31:0] debug_reg3,
    output [31:0] debug_pc_now,
    output [31:0] debug_inst,
    output [31:0] debug_imm,
    output [31:0] debug_RD1,
    output [31:0] debug_RD2,
    output [31:0] debug_alu_res,
    output [31:0] debug_in1,
    output [31:0] debug_in2


 
    );



    wire[31:0]  inst_rom_addr;
    wire[31:0]  inst_rom_rdata;
    wire[31:0]  data_ram_addr;
    wire[31:0]  data_ram_wdata;
    wire        data_ram_wen;
    wire[31:0]  data_ram_rdata;



    mycpu mycpu0(
        .rstn(rstn),                                  // input
        .clk(clk),                                  // input

        .inst_addr(inst_rom_addr),              // output
        .inst_rdata(inst_rom_rdata),            // input

        .dmem_addr(data_ram_addr),              // output
        .dmem_wdata(data_ram_wdata),            // output
        .dmem_wen(data_ram_wen),                // output
        .dmem_rdata(data_ram_rdata),             // input

        .debug_reg1(debug_reg1),
        .debug_reg2(debug_reg2),
        .debug_reg3(debug_reg3),
        .debug_pc_now(debug_pc_now),
        .debug_inst(debug_inst),
        .debug_imm(debug_imm),
        .debug_RD1(debug_RD1),
        .debug_RD2(debug_RD2),
        .debug_alu_res(debug_alu_res),
        .debug_in1(debug_in1),
        .debug_in2(debug_in2)
    );

    inst_rom inst_rom_4k(
        .a(inst_rom_addr[11:2]),                    // input wire [9 : 0] a
        .spo(inst_rom_rdata)                        // output wire [31 : 0] spo
    );

    wire ram_wen;
    wire[31:0] ram_addr;
    wire[31:0] ram_wdata;
    wire[31:0] ram_rdata;

    assign ram_addr = data_ram_addr;
    assign ram_wdata = data_ram_wdata;
    assign data_ram_rdata = ram_rdata;
    assign ram_wen = data_ram_wen;


    data_ram data_ram_4k(
        .a(ram_addr[11:2]),                         // input wire [9 : 0] a
        .d(ram_wdata),                              // input wire [31 : 0] d
        .clk(clk),                                  // input wire clk
        .we(ram_wen),                               // input wire we
        .spo(ram_rdata)                             // output wire [31 : 0] spo
    );


    // // debug
    // assign debug_inst=inst_rom_rdata;


endmodule
