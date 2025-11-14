`timescale 1ns / 1ps

module register (
    input wire clk,
    input wire rst,
    input wire load,
    input wire inr, // increment
    input wire dcr, // decrement
    input wire [7:0] data_in,
    output wire [7:0] out
);
    reg [7:0] store;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            store <= 8'b0;
        end else if (load) begin
            store <= data_in;
        end else if (inr) begin
            store <= store + 1;
        end else if (dcr) begin
            store <= store - 1;
        end
    end
    
    assign out = store;

endmodule