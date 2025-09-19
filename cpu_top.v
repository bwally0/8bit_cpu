`timescale 1ns / 1ps

// SW0 -> Start Clock
// SW1 -> RESET
// LED7-LED0 -> Output Register
// LED15 -> Clock

module cpu_top #(
    parameter CLOCK_DIV = 25_000_000
)(
    input wire CLK100MHZ,
    input wire [15:0] SW,
    output wire [15:0] LED,
    output wire [6:0] C, // 7seg
    output wire [7:0] AN // 7seg
);

    wire slow_clk;
    
    clk_divider #(
        .DIV_COUNT(CLOCK_DIV)
    ) clk_divider (
        .clk_in(CLK100MHZ),
        .enable(SW[0]),
        .clk_out(slow_clk)
    );
    
    wire rst = SW[1];
    
    // CONTROL SIGNALS
    wire pc_enable;
    wire pc_out_en;
    wire mar_load;
    wire ram_out_en;
    wire ir_load;
    wire ir_out_en;
    wire reg_a_load;
    wire reg_a_out_en;
    wire reg_b_load;
    wire alu_out_en;
    wire alu_sub;
    wire out_reg_load;
    wire hlt;
    
    // COMPONENT OUTPUTS
    wire [7:0] pc_out;
    wire [7:0] ram_out;
    wire [7:0] ir_out;
    wire [7:0] reg_a_out;
    wire [7:0] reg_b_out;
    wire [7:0] alu_out;
    wire [7:0] out_reg_out;
    
    // BUS
    reg [7:0] bus;
    
    wire cpu_clk = hlt ? 1'b0 : slow_clk;
    
    program_counter #(
        .WIDTH(8)
    ) pc (
        .clk(cpu_clk),
        .rst(rst),
        .enable(pc_enable),
        .data_in(8'b0), //unused
        .out(pc_out)
    );
    
    memory ram (
        .clk(cpu_clk),
        .rst(rst),
        .load(mar_load),
        .bus(bus),
        .out(ram_out)
    );
    
    instruction_reg ir (
        .clk(cpu_clk),
        .rst(rst),
        .load(ir_load),
        .data_in(bus),
        .out(ir_out)
    );
    
    reg_a reg_a_inst (
        .clk(cpu_clk),
        .rst(rst),
        .load(reg_a_load),
        .data_in(bus),
        .out(reg_a_out)
    );

    reg_b reg_b_inst (
        .clk(cpu_clk),
        .rst(rst),
        .load(reg_b_load),
        .data_in(bus),
        .out(reg_b_out)
    );
    
    alu #(
        .WIDTH(8)
    ) alu_inst (
        .a_in(reg_a_out),
        .b_in(reg_b_out),
        .sub(alu_sub),
        .result(alu_out)
    );
    
    output_register #(
        .WIDTH(8)
    ) out_reg (
        .clk(cpu_clk),
        .rst(rst),
        .load(out_reg_load),
        .data_in(bus),
        .out(out_reg_out)
    );
    
    control_unit cu (
        .clk(cpu_clk),
        .rst(rst),
        .opcode(ir_out[7:4]),
        .pc_enable(pc_enable),
        .pc_out(pc_out_en),
        .mar_load(mar_load),
        .ram_out(ram_out_en),
        .ir_load(ir_load),
        .ir_out(ir_out_en),
        .reg_a_load(reg_a_load),
        .reg_a_out(reg_a_out_en),
        .reg_b_load(reg_b_load),
        .alu_out(alu_out_en),
        .alu_sub(alu_sub),
        .out_reg_load(out_reg_load),
        .hlt(hlt)
    );
    
    seven_seg_driver seven_seg_driver (
        .clk(CLK100MHZ),
        .rst(rst),
        .value({24'b0, out_reg_out}),
        .C(C),
        .AN(AN)
    );
    
    // BUS MULTIPLEXER
    always @(*) begin
        if (pc_out_en)
            bus = pc_out;
        else if (ram_out_en)
            bus = ram_out;
        else if (ir_out_en)
            bus = {4'b0, ir_out[3:0]}; // operand
        else if (reg_a_out_en)
            bus = reg_a_out;
        else if (alu_out_en)
            bus = alu_out;
        else
            bus = 8'b0;
    end
    
    assign LED[15] = cpu_clk;
    assign LED[14] = rst;
    assign LED[13:8] = 6'b0;
    assign LED[7:0] = bus;
    
endmodule
