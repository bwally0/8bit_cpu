`timescale 1ns / 1ps

module instruction_reg(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] instr,
    output wire [3:0] opcode,
    output wire [3:0] operand
);

    always @(posedge clk) begin
        if (rst) begin
            instr <= 8'b0;
        end else if (load) begin
            instr <= data_in;
        end
    end

    // split instruction
    assign opcode  = instr[7:4];
    assign operand = instr[3:0];

endmodule
