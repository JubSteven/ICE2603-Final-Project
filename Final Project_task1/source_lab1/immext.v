//module immext(inst,pcsource,sext,i_lui,i_sw,shift,out_immediate);
//input [31:0] inst;
//input sext,i_lui,i_sw,shift;
//input [1:0] pcsource;  
//output [31:0] out_immediate;

//wire e= sext &inst[31];   // positive or negative sign at sext signal
//wire [19:0] imm = {20{e}};    // high 20 sign bit
//wire [31:0] itype_imm = {imm,inst[31:20]};
//wire [31:0] lui_imm =   ;//请补充完�?
//wire [31:0] sw_imm =    ;//请补充完�?
//wire [31:0] shift_imm =    ;//请补充完�?
//wire [31:0] bpc_offset =     ;//请补充完�?
//wire [31:0] jpc_offset = {{12{e}},inst[19:12],inst[20],inst[30:21],1'b0};

//assign out_immediate =  i_lui?lui_imm:         ;//请补充完�?


//endmodule
module immext(
        inst, pcsource, sext, i_lui, i_sw, shift, out_immediate
    );
    
    input [31:0] inst; // instruction
    input [1:0] pcsource;
    input sext, i_lui, i_sw, shift;
    output [31:0] out_immediate;

    wire [31:0] branchpc_offset, jalpc_offset, itype_imm, lui_imm, shift_imm, sw_imm;
    
    assign e = sext & inst[31];
    assign lui_imm = {inst[31:12], 12'b0};
    assign shift_imm = {{27{e}}, inst[24:20]};
    assign sw_imm = {{20{e}}, inst[31:25], inst[11:7]};
    
    // branchpc_offset adds a zero for aligning
    // it will be further shifted by one bit to the left 
    // in order to be aligned by word
    assign branchpc_offset = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
    assign jalpc_offset = {{12{e}}, inst[19:12], inst[20], inst[30:21], 1'b0};
    assign itype_imm = {{20{e}}, inst[31:20]};
    
    assign out_immediate = (i_lui) ? lui_imm:
                           (shift) ? shift_imm:
                           (i_sw) ? sw_imm:
                           (pcsource == 2'b01) ? branchpc_offset:
                           (pcsource == 2'b11) ? jalpc_offset:
                           itype_imm;
    
    
    
endmodule