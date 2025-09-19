`timescale 1ns / 1ps

module memory(
	input wire clk,
	input wire rst,
	input wire load,
	input wire [7:0] bus,
	output wire [7:0] out
);
    
    reg[3:0] mar;
    reg[7:0] ram[0:15];
    
    initial begin
        $readmemh("program.hex", ram);
    end
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            mar <= 4'b0;
        end else if (load) begin
            mar <= bus[3:0];
        end
    end
    
    assign out = ram[mar];
    
endmodule

