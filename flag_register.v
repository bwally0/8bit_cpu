`timescale 1ns / 1ps

module flag_register(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] data_in,
    input wire carry_in,
    output reg Z,
    output reg S,
    output reg CY
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Z <= 1'b0;
            S <= 1'b0;
            CY <= 1'b0;
        end else if (load) begin
            Z <= (data_in == 8'b0);
            S <= data_in[7];
            CY <= carry_in;
        end
    end
endmodule
