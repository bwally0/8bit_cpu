`timescale 1ns / 1ps

module program_counter #(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire load,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] pc
);

    always @(posedge clk) begin
        if (rst) begin
            pc <= 0;           // reset
        end else if (load) begin
            pc <= data_in;     // load from data_in
        end else if (enable) begin
            pc <= pc + 1'b1;   // increment
        end
    end
endmodule
