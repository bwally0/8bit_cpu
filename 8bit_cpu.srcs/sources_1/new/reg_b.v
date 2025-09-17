`timescale 1ns / 1ps

module register_b (
    input  wire clk,
    input  wire rst,
    input  wire load,
    input  wire [7:0] data_in,
    output reg [7:0] b_out
);

    always @(posedge clk) begin
        if (rst)
            b_out <= 8'b0;
        else if (load)
            b_out <= data_in;
    end

endmodule