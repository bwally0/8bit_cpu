`timescale 1ns / 1ps

module program_counter #(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [WIDTH-1:0] data_in,
    output wire [WIDTH-1:0] out
);
    reg [WIDTH-1:0] pc;

    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            pc <= {WIDTH{1'b0}};
        end else if (enable) begin
            pc <= pc + 1;
        end
    end

    assign out = pc;
    
    
endmodule
