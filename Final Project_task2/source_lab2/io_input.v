module io_input(
	addr, io_clk, io_read_data, in_port0, in_port1, in_port2
);

    input [31:0] addr;
    input io_clk;
    input [31:0] in_port0;
    input [31:0] in_port1;
    input [31:0] in_port2;
    output [31:0] io_read_data;

    reg [31:0] in_reg0;
    reg [31:0] in_reg1;
    reg [31:0] in_reg2;

    io_input_mux io_imput_mux2x32(in_reg0, in_reg1, in_reg2, addr[7:2], io_read_data);

    always @(posedge io_clk) begin
        in_reg0 <= in_port0;
        in_reg1 <= in_port1;
        in_reg2 <= in_port2;
    end

endmodule

module io_input_mux(
    input [31:0] a0,
    input [31:0] a1,
    input [31:0] a2,
    input [5:0] sel_addr,
    output reg [31:0] y
);

    always @* begin
        case (sel_addr)
            6'b100000: y = a0;  // in_port0 byte address 0x80
            6'b100001: y = a1;  // in_port1 byte address 0x84
            6'b100010: y = a2;  // in_port2 byte address 0x88
            default: y = 32'h0;
        endcase
    end

endmodule