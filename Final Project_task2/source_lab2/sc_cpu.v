module sc_cpu (clock, resetn, inst, mem, pc, wmem, aluout, data);
    input [31:0] inst, mem;
    input clock, resetn;
    output [31:0] pc, aluout, data;
    output wmem;
    
    wire [31:0]   pc4, branchpc, jalrpc, npc, immediate;
    // ra, rb being the output of reg
    // regf_din being the result of write-back
    wire [31:0]   ra, rb, regf_din; 
    wire [31:0]   alua, alub, alu_mem;
    wire [3:0]    aluc;
    wire [1:0]    pcsource;// 00 normal; 01 beq, bne; 10 jalr; 11 jal
    wire          zero, positive, wmem, wreg, m2reg, aluimm, sext, i_lui, i_sw, shift;
    
    // pc register unit, dff32
    dff32 ip (npc, clock, resetn, pc);  // define a D-register for PC
    
    
    // immediate data extent unit, immext
    immext ImmGen(inst, pcsource, sext, i_lui, i_sw, shift, immediate);// generate ext immediate,
    
    
    // register file
    regfile RegFile(
        .rna(inst[19:15]),
        .rnb(inst[24:20]),
        .d(regf_din),
        .wn(inst[11:7]),
        .we(wreg),
        .clk(clock),
        .clrn(resetn),
        .qa(ra),
        .qb(rb)
    );
    
    assign data = rb; // data is actually the WRITE Data for MEM
   
    // control unit, sc_cu
    sc_cu cu (inst, zero, positive, wmem, wreg, m2reg, aluc, aluimm,
         pcsource, sext, i_lui, i_sw, shift);
    
    mux2x32 ALUMux(
        .a0(rb),
        .a1(immediate),
        .s(aluimm),
        .y(alub)
    );
    
    
    // alu unit, accompanied with MEMMux for output selection
    alu ALU(
        .a(ra),
        .b(alub),
        .aluc(aluc),
        .s(aluout),
        .z(zero),
        .positive(positive)
    );
    
    mux2x32 MEMMux(
        .a0(aluout),
        .a1(mem),
        .s(m2reg),
        .y(alu_mem)
    );
    
    // next pc generate
    // branchpc = pc + immediate
    cla32 PCadder1(
        .pc(pc),
        .x1(immediate),
        .p4(branchpc)
    );
    
    // jalrpc = ra + immediate
    cla32 PCadder2(
        .pc(ra),
        .x1(immediate),
        .p4(jalrpc)
    );
    
    // pc4 = pc + 4
    cla32 PCadder3(
        .pc(pc),
        .x1(32'b100),
        .p4(pc4)
    );
    
    // use PCMux to generate new PC
    mux4x32 PCMux(
        .a0(pc4),
        .a1(branchpc),
        .a2(jalrpc),
        .a3(branchpc),
        .s(pcsource[1:0]),
        .y(npc)
    );
    
    
    // write back register file using WBMux for regf_din
    mux2x32 WBMux(
        .a0(alu_mem),
        .a1(pc4),
        .s(pcsource[1]),
        .y(regf_din)
    );
    
    
    
    
    endmodule