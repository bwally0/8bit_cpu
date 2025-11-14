 module control_unit (
    input wire clk,
    input wire rst,
    input wire [7:0] op,
    input wire [3:0] flags,
    output wire [31:0] out
);

    // [31] END
    // [30] HLT
    // [29] IR_LOAD
    // [28] REG_EN
    // [27] REG_LOAD
    // [26:25] REG_OP
    // [24] MAR_LOAD
    // [23] RAM_WRITE
    // [22] MEM_EN
    // [21] ALU_COMMIT
    // [20:17] ALU_OP
    // [16] A_LOAD
    // [15] TMP_LOAD
    // [14] FLAG_LOAD
    // [13:2] REG_FIELD
    // [1:0] UNUSED
    
    reg [3:0] stage;
    reg [46:0] ctrl_word;
    reg [46:0] ctrl_rom [0:4095];
    
    initial $readmemb("ctrl_rom.bin", ctrl_rom);
    
    always @(negedge clk or posedge rst) begin
        if (rst)
            stage <= 0;
        else if (ctrl_word[31])
            stage <= 0;
        else
            stage <= stage + 1;
    end
    
    wire s_flag = flags[3];
    wire z_flag = flags[2];
    wire p_flag = flags[1];
    wire c_flag = flags[0];
    
    always @(*) begin
        ctrl_word = ctrl_rom[{op, stage}];

        case (op)
            8'hCA: if (stage == 4 && !z_flag) ctrl_word = {1'b1, 31'b0}; // JZ
            8'hC2: if (stage == 4 &&  z_flag) ctrl_word = {1'b1, 31'b0}; // JNZ
            8'hDA: if (stage == 4 && !c_flag) ctrl_word = {1'b1, 31'b0}; // JC
            8'hD2: if (stage == 4 &&  c_flag) ctrl_word = {1'b1, 31'b0}; // JNC
            8'hFA: if (stage == 4 && !s_flag) ctrl_word = {1'b1, 31'b0}; // JM
            8'hF2: if (stage == 4 &&  s_flag) ctrl_word = {1'b1, 31'b0}; // JP
            8'hEA: if (stage == 4 && !p_flag) ctrl_word = {1'b1, 31'b0}; // JPE
            8'hE2: if (stage == 4 &&  p_flag) ctrl_word = {1'b1, 31'b0}; // JPO

            8'hCC: if (stage == 5 && !z_flag) ctrl_word = {1'b1, 31'b0}; // CZ
            8'hC4: if (stage == 5 &&  z_flag) ctrl_word = {1'b1, 31'b0}; // CNZ
            8'hDC: if (stage == 5 && !c_flag) ctrl_word = {1'b1, 31'b0}; // CC
            8'hD4: if (stage == 5 &&  c_flag) ctrl_word = {1'b1, 31'b0}; // CNC
            8'hEC: if (stage == 5 && !p_flag) ctrl_word = {1'b1, 31'b0}; // CPE
            8'hE4: if (stage == 5 &&  p_flag) ctrl_word = {1'b1, 31'b0}; // CPO
            8'hFC: if (stage == 5 && !s_flag) ctrl_word = {1'b1, 31'b0}; // CM
            8'hF4: if (stage == 5 &&  s_flag) ctrl_word = {1'b1, 31'b0}; // CP

            8'hC8: if (stage == 4 && !z_flag) ctrl_word = {1'b1, 31'b0}; // RZ
            8'hC0: if (stage == 4 &&  z_flag) ctrl_word = {1'b1, 31'b0}; // RNZ
            8'hD8: if (stage == 4 && !c_flag) ctrl_word = {1'b1, 31'b0}; // RC
            8'hD0: if (stage == 4 &&  c_flag) ctrl_word = {1'b1, 31'b0}; // RNC
            8'hE8: if (stage == 4 && !p_flag) ctrl_word = {1'b1, 31'b0}; // RPE
            8'hE0: if (stage == 4 &&  p_flag) ctrl_word = {1'b1, 31'b0}; // RPO
            8'hF8: if (stage == 4 && !s_flag) ctrl_word = {1'b1, 31'b0}; // RM
            8'hF0: if (stage == 4 &&  s_flag) ctrl_word = {1'b1, 31'b0}; // RP

            default: ;
        endcase
    end
    
    assign out = ctrl_word;

endmodule