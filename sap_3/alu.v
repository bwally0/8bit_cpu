`timescale 1ns / 1ps

module alu (
    input wire clk,
    input wire rst,
    
    input wire [7:0] data_in,
    
    input wire load_a,
    input wire load_tmp,
    input wire load_flags,
    input wire alu_commit,
    input wire [3:0] op,
    input wire cin,
    
    output reg [7:0] a_out,
    output wire [7:0] alu_out,
    output reg [3:0] flags_out
);
    reg [7:0] a_reg;
    reg [7:0] tmp_reg;
    reg [3:0] flags_reg;
    reg [8:0] result;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 8'b0;
            tmp_reg <= 8'b0;
            flags_reg <= 8'b0;
        end else begin
            if (load_a) a_reg <= data_in;
            if (load_tmp) tmp_reg <= data_in;
            if (load_flags) flags_reg <= data_in[3:0];
        end 
    end
    
    always @(*) begin
        case (op)
            4'b0000: result = a_reg + tmp_reg + cin; // ADD
            4'b0001: result = a_reg - tmp_reg - cin; // SUB
            4'b0010: result = {1'b0, a_reg & tmp_reg}; // AND
            4'b0011: result = {1'b0, a_reg | tmp_reg}; // OR
            4'b0100: result = {1'b0, a_reg ^ tmp_reg}; // XOR
            4'b0101: result = {1'b0, ~a_reg}; // NOT (CMA)
            4'b0110: result = a_reg + 1; // INC
            4'b0111: result = a_reg - 1; // DEC
            4'b1000: result = {a_reg[7], a_reg[6:0], cin}; // RAL
            4'b1001: result = {a_reg[0], cin, a_reg[7:1]}; // RAR
            4'b1010: result = {1'b0, a_reg}; // PASS A
            4'b1011: result = {1'b0, tmp_reg}; // PASS B
            default: result = 9'b0;
        endcase
    end
    
    // get flags
    wire flag_c = result[8];
    wire flag_s = result[7];
    wire flag_z = (result[7:0] == 8'b0);
    wire flag_p = ~(^result[7:0]); 
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            flags_reg <= 4'b0;
            a_reg <= 8'b0;
        end else if (alu_commit) begin
            a_reg <= result[7:0];
            flags_reg <= {flag_s, flag_z, flag_p, flag_c};
        end
    end
    
    assign alu_out = result[7:0];
    always @(*) a_out = a_reg;
    always @(*) flags_out = flags_reg;
  
endmodule
