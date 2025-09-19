 module control_unit (
    input wire clk,
    input wire rst,
    input wire [3:0] opcode,
    output reg pc_enable,
    output reg pc_out,
    output reg mar_load,
    output reg ram_out,
    output reg ir_load,
    output reg ir_out,
    output reg reg_a_load,
    output reg reg_a_out,
    output reg reg_b_load,
    output reg alu_out,
    output reg alu_sub,
    output reg out_reg_load,
    output reg hlt
);

    reg [2:0] t_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            t_state <= 3'd0;
        else if (!hlt)
            t_state <= (t_state == 3'd4) ? 3'd0 : t_state + 1'b1;
    end

    always @(*) begin
        pc_enable = 0;
        pc_out = 0;
        mar_load = 0;
        ram_out = 0;
        ir_load = 0;
        ir_out = 0;
        reg_a_load = 0;
        reg_a_out = 0;
        reg_b_load = 0;
        alu_out = 0;
        alu_sub = 0;
        out_reg_load = 0;
        hlt = 0;

        case (t_state)
            // FETCH INSTRUCTION
            3'd0: begin
                pc_out = 1;
                mar_load = 1;
            end

            3'd1: begin
                ram_out = 1;
                ir_load = 1;
                pc_enable = 1;
            end

            // EXECUTE
            3'd2: begin
                case (opcode)
                    4'h1, 4'h2, 4'h3: begin // LDA, ADD, SUB
                        ir_out = 1;
                        mar_load = 1;
                    end
                    4'hE: begin // OUT
                        reg_a_out = 1;
                        out_reg_load = 1;
                    end
                    4'hF: hlt = 1; // HLT
                endcase
            end

            3'd3: begin
                case (opcode)
                    4'h1: begin // LDA
                        ram_out = 1;
                        reg_a_load = 1;
                    end
                    4'h2: begin // ADD
                        ram_out = 1;
                        reg_b_load = 1;
                    end
                    4'h3: begin // SUB
                        ram_out = 1;
                        reg_b_load = 1;
                    end
                endcase
            end

            3'd4: begin
                case (opcode)
                    4'h2: begin // ADD
                        alu_out = 1;
                        reg_a_load = 1;
                    end
                    4'h3: begin // SUB
                        alu_sub    = 1;
                        alu_out = 1;
                        reg_a_load = 1;
                    end
                endcase
            end
        endcase
    end
endmodule