`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SJTU
// Engineer: 
// 
// Create Date: 2021/10/29 14:57:06
// Design Name: CYQ
// Module Name: sc_cpu_iotest
// Project Name: 32BIT RISC-V CPU IO TEST 
// Target Devices: ARTIX-7, xc7a50tcsg324-1
// Tool Versions: VIVADO 2020.2
// Description:DISPLAY THE SUM OF 2 5BIT-INPUT DATA AT THE LEDS AND DIGITRONS.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sc_cpu_iotest(
    input sys_rst_n,  //active low global reset
    input sys_clk_in, //100MHz clock
    input [4:0] sw_pin,//left 8 sw_pin
    input [4:0] dip_pin,//right 8 dip_pin
    output [7:0] seg_data_0_pin, //output DP1,G1,F1,E1,D1,C1,B1,A1, left
    output [7:0] seg_data_1_pin,  //output DP0,G0,F0,E0,D0,C0,B0,A0,  right
    output [7:0] seg_cs_pin, //DN1_K4,DN1_K3,DN1_K2,DN1_K0,DN0_K4,DN0_K3,DN0_K2,DN0_K1 ,left to right
    output [0:15] led_pin //left to right
     );
    
    wire [3:0] HEX4b7, HEX4b6, HEX4b5, HEX4b4, HEX4b3, HEX4b2, HEX4b1, HEX4b0;
    wire [31:0] in_port0, in_port1, in_port2;
    wire [31:0] out_port0, out_port1, out_port2;
    wire [31:0] pc, inst, aluout, memout, reg_18;
    
    wire [31:0] count, student_id;
    
    
    //clock_and_mem_clock unit, generate clock, imem_clock, dmem_clock  , add here
    clock_and_mem_clock clkgen(sys_clk_in, clock_out, imem_clock, dmem_clock);
    
    // added for final project. generate sys_clk_counter
    sys_clk_counter clk_counter(sys_clk_in, sys_rst_n, count);
    
    //extend in_port0 to 32bit,  in_port0 = {27'b0,sw_pin}; add here
    in_port inport1(sw_pin, in_port0);
    
    //extend in_port1 to 32bit,  in_port1 = {27'b0,dip_pin}; add here
    in_port inport2(dip_pin, in_port1);
    
    // assign in_port2 to be the value of count
    assign in_port2[31:0] = count;
    
    
    //sc_computer_main unit
    sc_computer_main computer_main(sys_rst_n, clock_out, imem_clock, dmem_clock,
    pc, inst, aluout, memout, out_port0, out_port1, out_port2,
    in_port0, in_port1, in_port2);
    
    
    
    //led sign
    assign led_pin[10:15] = out_port2[5:0];
    assign led_pin[0:4] = out_port0[4:0]; 
    assign led_pin[5:9] = out_port1[4:0]; 
    
    assign student_id[31:0] = 5'b10001;
    
    // out_port_hex2dec unit, outport the first few numbers of the student number
    out_port_hex2dec dec76(student_id, HEX4b7, HEX4b6);
    
    // out_port_hex2dec unit , gives the value of pc
    out_port_hex2dec dec54(out_port0, HEX4b5, HEX4b4);  // the maximum value
    
    // out_port_hex2dec unit, gives the value for reg_18
    out_port_hex2dec dec32(out_port1, HEX4b3, HEX4b2); // the minimum value
    
    // out_port_hex2dec unit, gives the value for in_port2
    out_port_hex2dec dec10(out_port2, HEX4b1, HEX4b0);  // the pc counter
     
    //display unit, seven segment decode and digitron drive 
    display display(
        .clk(sys_clk_in),
        .reset(sys_rst_n),
        .s({HEX4b7, HEX4b6, HEX4b5, HEX4b4, HEX4b3, HEX4b2, HEX4b1, HEX4b0}),
        .seg0(seg_data_0_pin),
        .seg1(seg_data_1_pin),
        .ans(seg_cs_pin)
    );

endmodule
