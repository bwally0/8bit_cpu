`timescale 1ns / 1ps

module cpu_top(
    input wire CLK100MHZ,
    input wire [15:0] SW,
    output wire [15:0] LED
);

    wire slow_clk;
    
    clk_divider clk_divider (
        .clk_in(CLK100MHZ),
        .enable(SW[15]),
        .clk_out(slow_clk)
    );
    
    assign LED[15] = slow_clk;
    assign LED[14:0] = 15'b0;
    
endmodule
