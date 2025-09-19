`timescale 1ns / 1ps

module output_register #(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] out
);

    always @(posedge clk) begin
        if (rst)
            out <= {WIDTH{1'b0}};
        else if (load)
            out <= data_in;
    end

endmodule
