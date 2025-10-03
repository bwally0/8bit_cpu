`timescale 1ns / 1ps

module alu (
    input wire [7:0] A,
    input wire [7:0] B,
    input wire cin,
    input wire [3:0] op,
    output wire [7:0] out,
    output wire cout
);
    reg [8:0] result;
    
    always @(*) begin
        case (op)
            4'b0000: result = A + B + cin; // ADD
            4'b0001: result = A - B - cin; // SUB
            4'b0010: result = {1'b0, A & B}; // AND
            4'b0011: result = {1'b0, A | B}; // OR
            4'b0100: result = {1'b0, A ^ B}; // XOR
            4'b0101: result = {1'b0, ~A}; // NOT (CMA)
            4'b0110: result = A + 1; // INC
            4'b0111: result = A - 1; // DEC
            4'b1000: result = {A[7], A[6:0], cin}; // RAL
            4'b1001: result = {A[0], cin, A[7:1]}; // RAR
            4'b1010: result = {1'b0, A}; // PASS A
            4'b1011: result = {1'b0, B}; // PASS B
            default: result = 9'b0;
        endcase
    end

    assign out  = result[7:0];
    assign cout = result[8];
    
endmodule
