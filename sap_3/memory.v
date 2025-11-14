`timescale 1ns / 1ps

module memory(
    input wire clk,
    input wire rst,
    input wire load_mar,
    input wire load_ram,
    input wire [15:0] data_in,
    output wire [7:0] out 
);

    reg [15:0] mar;
    (* ram_style = "block" *) reg [7:0] ram [0:65535];

    initial begin
        $readmemh("program.hex", ram);
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mar <= 16'h0000;
        end else begin
            if (load_mar)
                mar <= data_in;

            if (load_ram)
                ram[mar] <= data_in[7:0];
        end
    end

    assign out = ram[mar];
    
endmodule
