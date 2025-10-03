`timescale 1ns / 1ps

module clk_divider #(
    parameter DIV_COUNT = 25_000_000 // 2Hz clock
)(
    input wire clk_in,
    input wire enable,
    input wire hlt,
    output reg clk_out = 0
);
    reg [$clog2(DIV_COUNT)-1:0] counter = 0;
    
    always @(posedge clk_in) begin
        if (enable && !hlt) begin
            if (counter == DIV_COUNT - 1) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            counter <= 0;
            clk_out <= 0;
        end
    end
    
endmodule
