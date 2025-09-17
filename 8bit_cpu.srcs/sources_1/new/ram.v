`timescale 1ns / 1ps

module ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 256,
    parameter FILENAME = "program.hex"
)(
    input wire clk,
    input wire [WIDTH-1:0] addr,
    input wire write_en,           // write enable
    input wire out_en,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output wire [WIDTH-1:0] bus_out
);

    reg [WIDTH-1:0] memory [0:DEPTH-1];
    
    initial begin
        $readmemh(FILENAME, memory);
    end
    
    always @(posedge clk) begin
        if (write_en) begin
            memory[addr] <= data_in;
        end
        data_out <= memory[addr];
    end
    
    assign bus_out = out_en ? data_out : {WIDTH{1'bz}};
    
endmodule
