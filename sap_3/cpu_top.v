`timescale 1ns / 1ps

// SW0 -> start clk
// SW1 -> rst

module cpu_top #(
    parameter CLOCK_DIV = 25_000_000
)(
    input wire CLK100MHZ,
    input wire [15:0] SW,
    output wire [15:0] LED,
    output wire [6:0] C, // 7seg cathodes
    output wire [7:0] AN, // 7seg anodes
    output wire DP
);
    
    wire clk;
    wire rst = SW[1];
    wire hlt;
    
    clk_divider #(
        .DIV_COUNT(CLOCK_DIV)
    ) clk_divider (
        .clk_in(CLK100MHZ),
        .enable(SW[0]),
        .hlt(hlt),
        .clk_out(clk)
    );
    
    reg [15:0] bus;
    
    // control unit
    wire [31:0] ctrl_word;
    wire [7:0] ir_out;
    wire [3:0] alu_flags;

    control_unit CU (
        .clk(clk),
        .rst(rst),
        .op(ir_out),
        .flags(alu_flags),
        .out(ctrl_word)
    );
    
    // decode control word
    wire        end_cycle   = ctrl_word[31];
    assign      hlt         = ctrl_word[30];
    wire        ir_load     = ctrl_word[29];
    wire        reg_en      = ctrl_word[28];
    wire        reg_load    = ctrl_word[27];
    wire [1:0]  reg_op      = ctrl_word[26:25];
    wire        mar_load    = ctrl_word[24];
    wire        ram_write   = ctrl_word[23];
    wire        mem_en      = ctrl_word[22];
    wire        alu_commit  = ctrl_word[21];
    wire [3:0]  alu_op      = ctrl_word[20:17];
    wire        a_load      = ctrl_word[16];
    wire        tmp_load    = ctrl_word[15];
    wire        flag_load   = ctrl_word[14];
    wire [13:2] reg_field   = ctrl_word[13:2];  // {read_sel[4:0], load_sel[4:0]}

    wire [4:0] read_sel = reg_field[13:9];
    wire [4:0] load_sel = reg_field[8:4];
    
    // memory
    wire [7:0]  mem_out;
    wire [15:0] reg_out;
    
    memory MEM (
        .clk(clk),
        .rst(rst),
        .load_mar(mar_load),
        .load_ram(ram_write),
        .data_in(bus),
        .out(mem_out)
    );
    
    // register file
    register_file RF (
        .clk(clk),
        .rst(rst),
        .read_sel(read_sel),
        .load_sel(load_sel),
        .load(reg_load),
        .op(reg_op),
        .data_in(bus),
        .out(reg_out)
    );
    
    
    // instruction register
    ir IR (
        .clk(clk),
        .rst(rst),
        .load(ir_load),
        .bus(bus[7:0]),
        .out(ir_out)
    );
    
    // alu
    wire [7:0] alu_out;
    wire [7:0] a_out;
    wire [3:0] flags_out;
    alu ALU (
        .clk(clk),
        .rst(rst),
        .data_in(bus[7:0]),
        .load_a(a_load),
        .load_tmp(tmp_load),
        .load_flags(flag_load),
        .alu_commit(alu_commit),
        .op(alu_op),
        .cin(1'b0),
        .a_out(a_out),
        .alu_out(alu_out),
        .flags_out(flags_out)
    );

    assign alu_flags = flags_out;
    
    // bus multiplexer
    always @(*) begin
        case (1'b1)
            reg_en:  bus = reg_out;
            mem_en:  bus = {8'b0, mem_out};
            default: bus = 16'h0000;
        endcase
    end
    
    
    // 7 segment display
    seven_seg_driver display (
        .clk(CLK100MHZ),
        .slow_clk(clk),
        .rst(rst),
        .value(bus),
        .C(C),
        .AN(AN),
        .DP(DP)
    );

    assign LED = bus;

    
endmodule
