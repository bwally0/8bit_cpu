`timescale 1ns / 1ps

module program_counter (
    input wire clk,
    input wire rst,
    input wire inr,
    input wire load,
    input wire [15:0] data_in,
    output wire [15:0] out
);
    reg [15:0] pc;

    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            pc <= 16'b0;
        end else if (load) begin
            pc <= data_in;
        end else if (inr) begin
            pc <= pc + 1;
        end
    end

    assign out = pc;
    
endmodule
