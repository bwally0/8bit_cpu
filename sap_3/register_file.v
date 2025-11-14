`timescale 1ns / 1ps

module register_file(
    input wire clk,
    input wire rst,
    
    input wire [4:0] read_sel,
    input wire [4:0] load_sel,
    input wire load,
    
    input wire [1:0] op, // 00=none, 01=INC, 10=DEC, 11=INC2
    
    input wire [15:0] data_in,
    output reg [15:0] out
);
    
    // 0:B  1:C  2:D  3:E  4:H  5:L  6:W  7:Z  8:PCH  9:PCL  10:SPH  11:SPL
    // pairs: B-C, D-E, H-L, W-Z, PC, SP
    reg [7:0] data [0:11];
    
    localparam OP_NONE = 2'b00;
    localparam OP_INC = 2'b01;
    localparam OP_DEC = 2'b10;
    localparam OP_INC2 = 2'b11;
    
    wire read_pair = read_sel[4]; // read pair
    wire load_pair = load_sel[4]; // load pair
    wire [3:0] read_index = read_sel[3:0];
    wire [3:0] load_index = load_sel[3:0];
    
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 12; i = i + 1)
                data[i] <= 8'b0;
        end else begin
            case (op)
                OP_INC:
                    {data[load_index], data[load_index + 1]} <=
                        {data[load_index], data[load_index + 1]} + 16'h0001;
                OP_DEC:
                    {data[load_index], data[load_index + 1]} <=
                        {data[load_index], data[load_index + 1]} - 16'h0001;
                OP_INC2:
                    {data[load_index], data[load_index + 1]} <=
                        {data[load_index], data[load_index + 1]} + 16'h0002;
                default: ;
            endcase

            if (load) begin
                if (load_pair)
                    {data[load_index], data[load_index + 1]} <= data_in;
                else
                    data[load_index] <= data_in[7:0];
            end
        end
    end
    
    always @(*) begin
        if (read_pair)
            out = {data[read_index], data[read_index + 1]};
        else
            out = {8'h00, data[read_index]};
    end
    
endmodule
