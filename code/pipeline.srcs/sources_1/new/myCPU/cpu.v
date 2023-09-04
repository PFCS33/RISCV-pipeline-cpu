`include "macro.vh"
`timescale 1ns / 1ps

module mycpu(
    input         rstn,
    input         clk,

    // rom 指令存储器接口
    output [31:0] inst_addr,
    input  [31:0] inst_rdata,

    // ram 内存接口
    input  [31:0] dmem_rdata,
    output        dmem_wen,
    output [31:0] dmem_addr,
    output [31:0] dmem_wdata,
    
    // debug
    output [`BIT_WIDTH] debug_reg1,
    output [`BIT_WIDTH] debug_reg2,
    output [`BIT_WIDTH] debug_reg3,
    output [`BIT_WIDTH] debug_pc_now,
    output [`BIT_WIDTH] debug_inst,
    output [`BIT_WIDTH] debug_imm,
    output [`BIT_WIDTH] debug_RD1,
    output [`BIT_WIDTH] debug_RD2,
    output [`BIT_WIDTH] debug_alu_res,
    output [`BIT_WIDTH] debug_in1,
    output [`BIT_WIDTH] debug_in2
 );



/* wires of pipeline register-------------------------------------------------------------------------- */
// reg if_id 
wire [`BIT_WIDTH] if_id_pc, if_id_inst;
wire if_id_we, if_id_empty;

// reg id_exe
wire id_exe_empty;
wire [`BIT_WIDTH]id_exe_inst, id_exe_pc;
wire [`BIT_WIDTH]id_exe_imm, id_exe_RD1, id_exe_RD2;
wire id_exe_alu_src, id_exe_reg_src, id_exe_reg_we, id_exe_dmem_we, id_exe_branch, id_exe_dmem_read;
wire [3:0] id_exe_alu_op;

// reg exe_mem
wire [`BIT_WIDTH] exe_mem_inst, exe_mem_pc;
wire  [`BIT_WIDTH] exe_mem_imm, exe_mem_RD1, exe_mem_RD2;
wire  exe_mem_reg_src, exe_mem_reg_we, exe_mem_dmem_we, exe_mem_branch, exe_mem_dmem_read;
wire  [`BIT_WIDTH] exe_mem_alu_res;
wire  exe_mem_jump;

// reg mem_wb
wire [`BIT_WIDTH] mem_wb_inst;
wire [`BIT_WIDTH] mem_wb_alu_res;
wire mem_wb_reg_we, mem_wb_reg_src;
wire [`BIT_WIDTH] mem_wb_dmem_data;


/*If stage -------------------------------------------------------------------------- */
wire [`BIT_WIDTH] pc, npc;
wire pc_we;
wire [`BIT_WIDTH] inst;

// pc
pc u_pc(
    .clk(clk), .rstn(rstn),
    .pc_we(pc_we), .npc(npc), .pc(pc)
    );

// npc
npc u_npc(
    .pc_now(pc),
    .branch(exe_mem_branch),
    .jump(exe_mem_jump),
    .imm(exe_mem_imm),
    .exe_mem_opcode(exe_mem_inst[6:0]), .exe_mem_pc(exe_mem_pc), .exe_mem_alu_res(exe_mem_alu_res),
    .pc_new(npc)
);
/*inst rom interface -------------------------------------------------------------------------- */
assign inst_addr = pc;
assign inst = inst_rdata;


/* ID Stage-------------------------------------------------------------------------- */
// reg_if_id
reg_if_id u_reg_if_id(
    .clk(clk), .rstn(rstn),
    .if_id_we(if_id_we), .empty(if_id_empty),
    .inst(inst), .pc(pc),
    .if_id_inst(if_id_inst), .if_id_pc(if_id_pc)
);

// cu
wire [3:0] alu_op;
wire alu_src, reg_src, reg_we, dmem_we, branch, dmem_read;

cu u_cu(
    .inst(if_id_inst),
    .alu_op(alu_op), .alu_src(alu_src), 
    .reg_src(reg_src), .reg_we(reg_we),
    .dmem_we(dmem_we), .branch(branch),
    .dmem_read(dmem_read));

// imm_gen
wire [`BIT_WIDTH] imm;
imm_gen u_imm_gen(
    .inst(if_id_inst), 
    .imm(imm));

// rf
wire[`BIT_WIDTH] WD;
wire [`BIT_WIDTH] RD1_tmp, RD2_tmp;
rf u_rf(
    .clk(clk), .rstn(rstn),
    .we(mem_wb_reg_we),
    .RA1(if_id_inst[19:15]), .RA2(if_id_inst[24:20]), 
    .WA(mem_wb_inst[11:7]), .WD(WD), 
    .RD1(RD1_tmp), .RD2(RD2_tmp),

    // debug
    .debug_reg1(debug_reg1), .debug_reg2(debug_reg2), .debug_reg3(debug_reg3)
);

//get forward control of rd1 & rd2
wire [`BIT_WIDTH] RD1, RD2;
wire forward_rd1, forward_rd2;
forwarding_mem_wb_2 u_forwarding_mem_wb_2(
    .mem_wb_reg_we(mem_wb_reg_we),
    .mem_wb_rd(mem_wb_inst[11:7]),
    .if_id_rs1(if_id_inst[19:15]), .if_id_rs2(if_id_inst[24:20]),
    .forward_rd1(forward_rd1), .forward_rd2(forward_rd2)
);
// get "real" rd1 & rd2
mux2 u_rd1_mux2(
    .op1(RD1_tmp), .op2(WD), 
    .ctr(forward_rd1),
    .res(RD1)
);
mux2 u_rd2_mux2(
    .op1(RD2_tmp), .op2(WD),
    .ctr(forward_rd2),
    .res(RD2)
);

/* EXE Stage -------------------------------------------------------------------------- */
// reg_id_exe
reg_id_exe u_reg_id_exe(
    .clk(clk), .rstn(rstn),
    .empty(id_exe_empty),
    .inst(if_id_inst), .pc(if_id_pc),
    .imm(imm), .RD1(RD1), .RD2(RD2),
    .alu_src(alu_src), .reg_src(reg_src), .reg_we(reg_we),
    .dmem_we(dmem_we), .branch(branch), .dmem_read(dmem_read),
    .alu_op(alu_op),
    .id_exe_inst(id_exe_inst), .id_exe_pc(id_exe_pc),
    .id_exe_imm(id_exe_imm), .id_exe_RD1(id_exe_RD1), .id_exe_RD2(id_exe_RD2),
    .id_exe_alu_src(id_exe_alu_src), .id_exe_reg_src(id_exe_reg_src), .id_exe_reg_we(id_exe_reg_we), 
    .id_exe_dmem_we(id_exe_dmem_we), .id_exe_branch(id_exe_branch), .id_exe_dmem_read(id_exe_dmem_read),
    .id_exe_alu_op(id_exe_alu_op)
);

// get forward control of rs1 & rs2
wire[1:0] forward_in1, forward_in2;
forward_exe_mem_1 u_forward_exe_mem_1(
    .exe_mem_reg_we(exe_mem_reg_we), .exe_mem_rd(exe_mem_inst[11:7]),
    .mem_wb_reg_we(mem_wb_reg_we), .mem_wb_rd(mem_wb_inst[11:7]),
    .id_exe_rs1(id_exe_inst[19:15]), .id_exe_rs2(id_exe_inst[24:20]), .id_exe_opcode(id_exe_inst[6:0]),
    .forward_in1(forward_in1), .forward_in2(forward_in2)
);

// get "real" in1 & in2 for alu
wire [`BIT_WIDTH] in1, in2, in2_tmp;
mux3 u_in1_mux3(
    .op1(id_exe_RD1), .op2(WD), .op3(exe_mem_alu_res),
    .ctr(forward_in1),
    .res(in1)
    );
mux3 u_in2_tmp_mux3(
    .op1(id_exe_RD2), .op2(WD), .op3(exe_mem_alu_res),
    .ctr(forward_in2),
    .res(in2_tmp)
);
mux2 u_in2_mux3(
    .op1(in2_tmp), .op2(id_exe_imm),
    .ctr(id_exe_alu_src),
    .res(in2)
);

// alu
wire [`BIT_WIDTH] alu_res;
wire ZF;
alu u_alu(
    .in1(in1), .in2(in2),
    .alu_op(id_exe_alu_op),
    .ZF(ZF),
    .res(alu_res)
);

// branch judge
wire jump;
branch_judge u_branch_judge(
    .inst(id_exe_inst),
    .in1(in1), .in2(in2),
    .jump(jump)
);

/* MEM Stage -------------------------------------------------------------------------- */
// reg_exe_mem
reg_exe_mem u_reg_exe_mem(
    .clk(clk), .rstn(rstn),
    .inst(id_exe_inst), .pc(id_exe_pc),
    .imm(id_exe_imm), .RD1(id_exe_RD1), .RD2(id_exe_RD2),
    .reg_src(id_exe_reg_src), .reg_we(id_exe_reg_we), .dmem_we(id_exe_dmem_we),
    .branch(id_exe_branch), .dmem_read(id_exe_dmem_read), .alu_res(alu_res),
    .jump(jump),
    .exe_mem_inst(exe_mem_inst), .exe_mem_pc(exe_mem_pc), 
    .exe_mem_imm(exe_mem_imm), .exe_mem_RD1(exe_mem_RD1), .exe_mem_RD2(exe_mem_RD2), 
    .exe_mem_reg_src(exe_mem_reg_src), .exe_mem_reg_we(exe_mem_reg_we), .exe_mem_dmem_we(exe_mem_dmem_we), 
    .exe_mem_branch(exe_mem_branch), .exe_mem_dmem_read(exe_mem_dmem_read), .exe_mem_alu_res(exe_mem_alu_res),
    .exe_mem_jump(exe_mem_jump)
);

// get forward control of wd
wire forward_wd;
forwarding_mem_wb_1 u_forwarding_mem_wb_1(
    .exe_mem_dmem_we(exe_mem_dmem_we),
    .exe_mem_rs2(exe_mem_inst[24:20]),
    .mem_wb_reg_we(mem_wb_reg_we),
    .mem_wb_rd(mem_wb_inst[11:7]),
    .forward_wd(forward_wd)
);
// get "real" dmem wd
wire [`BIT_WIDTH] dmem_WD;
mux2 u_dmem_wd_mux2(
    .op1(exe_mem_RD2), .op2(WD),
    .ctr(forward_wd),
    .res(dmem_WD)
);
// dmem interface
wire[`BIT_WIDTH] dmem_data;
assign dmem_data= dmem_rdata;
assign dmem_wen=exe_mem_dmem_we;
assign dmem_addr = exe_mem_alu_res; 
assign dmem_wdata=dmem_WD;


/* WB Stage-------------------------------------------------------------------------- */
// reg_mem_wb
reg_mem_wb u_reg_mem_wb(
    .clk(clk), .rstn(rstn),
    .inst(exe_mem_inst), .pc(exe_mem_pc),
    .alu_res(exe_mem_alu_res),
    .reg_we(exe_mem_reg_we), .reg_src(exe_mem_reg_src),
    .dmem_data(dmem_data),

    .mem_wb_inst(mem_wb_inst), .mem_wb_alu_res(mem_wb_alu_res),
    .mem_wb_reg_we(mem_wb_reg_we), .mem_wb_reg_src(mem_wb_reg_src),
    .mem_wb_dmem_data(mem_wb_dmem_data)
);

// get "real" WD
mux2 u_wd_mux2(
    .op1(mem_wb_alu_res), .op2(mem_wb_dmem_data),
    .ctr(mem_wb_reg_src),
    .res(WD)
);

/*nop detect -------------------------------------------------------------------------- */
nop_detect u_nop_detect(
    .clk(clk),
    .id_exe_dmem_read(id_exe_dmem_read),
    .if_id_rs1(if_id_inst[19:15]), .if_id_rs2(if_id_inst[24:20]), .id_exe_rd(id_exe_inst[11:7]),
    .if_id_opcode(if_id_inst[6:0]), .id_exe_opcode(id_exe_inst[6:0]), .exe_mem_opcode(exe_mem_inst[6:0]),
    .pc_we(pc_we), .if_id_we(if_id_we),
    .if_id_empty(if_id_empty), .id_exe_empty(id_exe_empty)
);
 


/* -------------------------------------------------------------------------- */
//debug
assign debug_pc_now= pc;
assign debug_imm=imm;
assign debug_inst = id_exe_inst;
assign debug_RD1=RD1;
assign debug_RD2= RD2;
assign debug_alu_res = alu_res;
assign debug_in1 = in1;
assign debug_in2 = in2;



endmodule