`timescale 1ns / 1ps

module reg_a (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] data_in,
    output wire [7:0] out
);
    reg [7:0] reg_a;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            reg_a <= 8'b0;
        end else if (load) begin
            reg_a <= data_in;
        end
    end
    
    assign out = reg_a;

endmodule