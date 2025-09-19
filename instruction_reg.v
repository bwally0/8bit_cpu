`timescale 1ns / 1ps

module instruction_reg(
	input wire clk,
	input wire rst,
	input wire load,
	input wire [7:0] data_in,
	output wire [7:0] out
);

    reg[7:0] ir;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            ir <= 8'b0;
        end else if (load) begin
            ir <= data_in;
        end
    end
    
    assign out = ir;

endmodule

