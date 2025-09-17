`timescale 1ns / 1ps

module register_a (
    input wire clk,
    input wire rst,
    input wire load,
    input wire out_en,
    input wire [7:0] data_in,
    output reg [7:0] a_out,
    output wire [7:0] bus_out
);

    always @(posedge clk) begin
        if (rst)
            a_out <= 8'b0;
        else if (load)
            a_out <= data_in;
    end

    assign bus_out = out_en ? a_out : 8'bz;

endmodule