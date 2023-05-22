
module sc_computer_main (
    resetn,clock,imem_clock,dmem_clock,pc,inst,aluout,memout,
    out_port0,out_port1,out_port2,in_port0,in_port1,in_port2);
    
    input resetn, clock, imem_clock, dmem_clock;
    input [31:0] in_port0, in_port1, in_port2;
    output [31:0] pc, inst, aluout, memout;
    output [31:0] out_port0, out_port1, out_port2;
    wire   [31:0] data;
    wire          wmem; // all these "wire"s are used to connect or interface the cpu,dmem,imem and so on.
    
    sc_cpu cpu(
        .clock(clock),
        .resetn(resetn),
        .inst(inst),
        .mem(memout),
        .pc(pc),
        .wmem(wmem),
        .aluout(aluout),
        .data(data));
    
    //  sc_instmem, instruction memory.  
    sc_instmem  imem (
        .addr(pc),
        .inst(inst),
        .clock(clock),
        .imem_clock(imem_clock)
        );
    
    //sc_datamem, data memory and IO module (modified the inputs).      
    sc_datamem  dmem(
        .resetn(resetn),
        .addr(aluout),
        .datain(data), // IMPORTANT! Denote 'data' as Write data for DM
        .dataout(memout), // IMPORTANT! Denote 'memout' for eventual output of DM
        .we(wmem),
        .clock(clock),
        .dmem_clock(dmem_clock),
        .out_port0(out_port0),
        .out_port1(out_port1),
        .out_port2(out_port2),
        .in_port0(in_port0),
        .in_port1(in_port1),
        .in_port2(in_port2)
    ); 

endmodule



