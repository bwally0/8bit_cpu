`timescale 1ns / 1ps

module memory(
    input wire clk,
    input wire rst,

    input wire [15:0] data_in,   // bus
    output wire [15:0] out,      // MDR to bus

    // control signals
    input wire mar_load,         // load MAR from bus
    input wire mdr_load_bus,     // load MDR fully from bus (16 bits)
    input wire mdr_load_low,     // load MDR[7:0] from memory[MAR]
    input wire mdr_load_high,    // load MDR[15:8] from memory[MAR]
    input wire ram_write         // write MDR.low (or MDR.full) to memory[MAR]
);

    reg [15:0] mar;
    reg [15:0] mdr;
    reg [7:0] ram [0:255];

    assign out = mdr;

    // init memory from file
    initial begin
        $readmemh("program.hex", ram);
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mar <= 16'b0;
            mdr <= 16'b0;
        end else begin
            if (mar_load)
                mar <= data_in;

            if (mdr_load_bus)
                mdr <= data_in;

            if (mdr_load_low)
                mdr[7:0] <= ram[mar];

            if (mdr_load_high)
                mdr[15:8] <= ram[mar];

            if (ram_write) begin
                ram[mar]     <= mdr[7:0];
                ram[mar + 1] <= mdr[15:8];
            end
        end
    end
endmodule
