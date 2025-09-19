`timescale 1ns / 1ps

module reg_b ( 
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] data_in,
    output wire [7:0] out
);
    reg [7:0] reg_b;

    always @(posedge clk, posedge rst) begin
        if (rst) begin 
            reg_b <= 8'b0;
        end else if (load) begin
            reg_b <= data_in;
        end
    end
    
    assign out = reg_b;

endmodule