`timescale 1ns / 1ps

module alu #(
    parameter WIDTH = 8
)(
    input wire [WIDTH-1:0] a_in,
    input wire [WIDTH-1:0] b_in,
    input wire sub,
    output wire [WIDTH-1:0] result
);

    assign result  = sub ? (a_in - b_in) : (a_in + b_in);

endmodule
