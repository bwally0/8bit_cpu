`timescale 1ns / 1ps

// SW0 -> start clk
// SW1 -> rst
// bus -> LED0-15

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
    
    // BUS
    reg [15:0] bus;
    always @(*) begin
        case (1'b1)
            pc_en:   bus = pc_out;
            mdr_en:  bus = mdr_out;
            a_en:    bus = {8'b0, a_out};
            b_en:    bus = {8'b0, b_out};
            c_en:    bus = {8'b0, c_out};
            tmp_en:  bus = {8'b0, tmp_out};
            alu_en:  bus = {8'b0, alu_out};
            default: bus = 16'b0; // idle
        endcase
    end
    
    // PROGRAM COUNTER
    wire pc_inr;
    wire pc_load;
    wire pc_en;
    wire [15:0] pc_out;
    program_counter pc (
        .clk(clk),
        .rst(rst),
        .inr(pc_inr),
        .load(pc_load),
        .data_in(bus),
        .out(pc_out)
    );
    
    // INSTRUCTION REGISTER
    wire ir_load;
    wire [7:0] ir_out;
    register ir (
        .clk(clk),
        .rst(rst),
        .load(ir_load),
        .inr(1'b0),
        .dcr(1'b0),
        .data_in(bus[7:0]), // 8-bit opcode
        .out(ir_out)
    );
    
    // MEMORY
    wire mar_load;
    wire mdr_load_bus;
    wire mdr_load_low;
    wire mdr_load_high;
    wire mdr_en;
    wire ram_write;
    wire [15:0] mdr_out;
    memory mem (
        .clk(clk),
        .rst(rst),
        .data_in(bus),
        .out(mdr_out),
        .mar_load(mar_load),
        .mdr_load_bus(mdr_load_bus),
        .mdr_load_low(mdr_load_low),
        .mdr_load_high(mdr_load_high),
        .ram_write(ram_write)
    );
    
    // REG A (Accumulator)
    wire a_load;
    wire a_inr;
    wire a_dcr;
    wire a_en;
    wire [7:0] a_out;
    register a (
        .clk(clk),
        .rst(rst),
        .load(a_load),
        .inr(a_inr),
        .dcr(a_dcr),
        .data_in(bus[7:0]),
        .out(a_out)
    );
    
    // REG TMP (Temporary)
    wire tmp_load;
    wire tmp_inr;
    wire tmp_dcr;
    wire tmp_en;
    wire [7:0] tmp_out;
    register tmp (
        .clk(clk),
        .rst(rst),
        .load(tmp_load),
        .inr(tmp_inr),
        .dcr(tmp_dcr),
        .data_in(bus[7:0]),
        .out(tmp_out)
    );
    
    // REG B
    wire b_load;
    wire b_inr;
    wire b_dcr;
    wire b_en;
    wire [7:0] b_out;
    register b (
        .clk(clk),
        .rst(rst),
        .load(b_load),
        .inr(b_inr),
        .dcr(b_dcr),
        .data_in(bus[7:0]),
        .out(b_out)
    );

    // REG C
    wire c_load;
    wire c_inr;
    wire c_dcr;
    wire c_en;
    wire [7:0] c_out;
    register c (
        .clk(clk),
        .rst(rst),
        .load(c_load),
        .inr(c_inr),
        .dcr(c_dcr),
        .data_in(bus[7:0]),
        .out(c_out)
    );
    
    // ALU
    wire [3:0] alu_op;
    wire alu_en;
    wire [7:0] alu_out;
    wire alu_cout;
    alu alu (
        .A(a_out),
        .B(tmp_out),
        .cin(1'b0),
        .op(alu_op),
        .out(alu_out),
        .cout(alu_cout)
    );
    
    // FLAG REG
    wire flag_load;
    wire Z;
    wire S;
    wire CY;
    flag_register flag (
        .clk(clk),
        .rst(rst),
        .load(flag_load),
        .data_in(alu_out),
        .carry_in(alu_cout),
        .Z(Z),
        .S(S),
        .CY(CY)
    );
    
    // OUTPUT REG
    wire out_load;
    wire [7:0] out_out;
    register out (
        .clk(clk),
        .rst(rst),
        .load(out_load),
        .inr(1'b0),
        .dcr(1'b0),
        .data_in(bus[7:0]),
        .out(out_out)
    );
    
    // CONTROL UNIT
    wire [45:0] cu_out;
    control_unit cu(
        .clk(clk),
        .rst(rst),
        .opcode(ir_out),
        .Z(Z),
        .S(S),
        .out(cu_out)
    );
    
    assign hlt       = cu_out[45];
    assign pc_en     = cu_out[44];
    assign mdr_en    = cu_out[43];
    assign a_en      = cu_out[42];
    assign b_en      = cu_out[41];
    assign c_en      = cu_out[40];
    assign tmp_en    = cu_out[39];
    assign alu_en    = cu_out[38];
    assign sp_en     = cu_out[37];
    assign io_en     = cu_out[36];
    assign pc_load   = cu_out[35];
    assign pc_inr    = cu_out[34];
    assign ir_load   = cu_out[33];
    assign a_load    = cu_out[32];
    assign a_inr     = cu_out[31];
    assign a_dcr     = cu_out[30];
    assign b_load    = cu_out[29];
    assign b_inr     = cu_out[28];
    assign b_dcr     = cu_out[27];
    assign c_load    = cu_out[26];
    assign c_inr     = cu_out[25];
    assign c_dcr     = cu_out[24];
    assign tmp_load  = cu_out[23];
    assign tmp_inr   = cu_out[22];
    assign tmp_dcr   = cu_out[21];
    assign out_load  = cu_out[20];
    assign sp_load   = cu_out[19];
    assign sp_inr    = cu_out[18];
    assign sp_dcr    = cu_out[17];
    assign mar_load  = cu_out[16];
    assign mdr_load_bus = cu_out[15];
    assign mdr_load_low = cu_out[14];
    assign mdr_load_high = cu_out[13];
    assign ram_write = cu_out[12];
    assign alu_op    = cu_out[11:8];
    assign flag_load = cu_out[7];
    assign io_load   = cu_out[6];
    assign unused5   = cu_out[5];
    assign unused4   = cu_out[4];
    assign unused3   = cu_out[3];
    assign unused2   = cu_out[2];
    assign unused1   = cu_out[1];
    assign unused0   = cu_out[0];
        
    seven_seg_driver display (
        .clk(CLK100MHZ),
        .slow_clk(clk),
        .rst(rst),
        .value({24'b0, out_out}),
        .C(C),
        .AN(AN),
        .DP(DP)
    );
    
    assign LED = bus;
    
endmodule
