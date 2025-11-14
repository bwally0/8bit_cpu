`timescale 1ns / 1ps

module seven_seg_driver(
    input wire clk, // cpu fast clk
    input wire slow_clk, // cpu slow clk
    input wire rst,
    input wire [31:0] value,
    output reg [6:0] C,
    output reg [7:0] AN,
    output reg DP
);

    reg [16:0] refresh_count = 0; 
    wire [2:0] digit_sel;

    always @(posedge clk or posedge rst) begin
        if (rst)
            refresh_count <= 0;
        else
            refresh_count <= refresh_count + 1;
    end

    assign digit_sel = refresh_count[16:14];

    reg [3:0] digit;

    always @(*) begin
        case (digit_sel)
            3'b000: begin AN = 8'b11111110; digit = value[3:0];   end
            3'b001: begin AN = 8'b11111101; digit = value[7:4];   end
            3'b010: begin AN = 8'b11111011; digit = value[11:8];  end
            3'b011: begin AN = 8'b11110111; digit = value[15:12]; end
            3'b100: begin AN = 8'b11101111; digit = value[19:16]; end
            3'b101: begin AN = 8'b11011111; digit = value[23:20]; end
            3'b110: begin AN = 8'b10111111; digit = value[27:24]; end
            3'b111: begin AN = 8'b01111111; digit = value[31:28]; end
            default: begin AN = 8'b11111111; digit = 4'b0000; end
        endcase
    end

    always @(*) begin
        case (digit)
            4'h0: C = 7'b1000000;
            4'h1: C = 7'b1111001;
            4'h2: C = 7'b0100100;
            4'h3: C = 7'b0110000;
            4'h4: C = 7'b0011001;
            4'h5: C = 7'b0010010;
            4'h6: C = 7'b0000010;
            4'h7: C = 7'b1111000;
            4'h8: C = 7'b0000000;
            4'h9: C = 7'b0010000;
            4'hA: C = 7'b0001000;
            4'hB: C = 7'b0000011;
            4'hC: C = 7'b1000110;
            4'hD: C = 7'b0100001;
            4'hE: C = 7'b0000110;
            4'hF: C = 7'b0001110;
            default: C = 7'b1111111;
        endcase
        
        DP = ~slow_clk; 
    end

endmodule
