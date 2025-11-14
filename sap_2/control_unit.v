 module control_unit (
    input wire clk,
    input wire rst,
    input wire [7:0] opcode,
    input wire Z,
    input wire S,
    output wire [45:0] out
);

    localparam SIG_END        = 46;
    localparam SIG_HLT        = 45;
    
    localparam SIG_PC_EN      = 44;
    localparam SIG_MDR_EN     = 43;
    localparam SIG_A_EN       = 42;
    localparam SIG_B_EN       = 41;
    localparam SIG_C_EN       = 40;
    localparam SIG_TMP_EN     = 39;
    localparam SIG_ALU_EN     = 38;
    localparam SIG_SP_EN      = 37;
    localparam SIG_IO_EN      = 36;
    
    localparam SIG_PC_LOAD    = 35;
    localparam SIG_PC_INR     = 34;
    localparam SIG_IR_LOAD    = 33;
    
    localparam SIG_A_LOAD     = 32;
    localparam SIG_A_INR      = 31;
    localparam SIG_A_DCR      = 30;
    
    localparam SIG_B_LOAD     = 29;
    localparam SIG_B_INR      = 28;
    localparam SIG_B_DCR      = 27;
    
    localparam SIG_C_LOAD     = 26;
    localparam SIG_C_INR      = 25;
    localparam SIG_C_DCR      = 24;
    
    localparam SIG_TMP_LOAD   = 23;
    localparam SIG_TMP_INR    = 22;
    localparam SIG_TMP_DCR    = 21;
    
    localparam SIG_OUT_LOAD   = 20;
    
    localparam SIG_SP_LOAD    = 19;
    localparam SIG_SP_INR     = 18;
    localparam SIG_SP_DCR     = 17;
    
    localparam SIG_MAR_LOAD   = 16;
    localparam SIG_MDR_LOADB  = 15;
    localparam SIG_MDR_LOADL  = 14;
    localparam SIG_MDR_LOADH  = 13;
    localparam SIG_RAM_WRITE  = 12;
    
    localparam SIG_ALU_OP3    = 11;
    localparam SIG_ALU_OP2    = 10;
    localparam SIG_ALU_OP1    = 9;
    localparam SIG_ALU_OP0    = 8;
    
    localparam SIG_FLAG_LOAD  = 7;
    
    localparam SIG_IO_LOAD    = 6;
    
    localparam SIG_UNUSED5    = 5;
    localparam SIG_UNUSED4    = 4;
    localparam SIG_UNUSED3    = 3;
    localparam SIG_UNUSED2    = 2;
    localparam SIG_UNUSED1    = 1;
    localparam SIG_UNUSED0    = 0;

    reg [3:0] stage;
    reg [7:0] opcode_reg;
    reg [46:0] ctrl_word;
    reg [46:0] ctrl_rom [0:4095];
    initial $readmemb("ctrl_rom.bin", ctrl_rom);
    
    always @(negedge clk or posedge rst) begin
        if (rst)
            stage <= 0;
        else if (ctrl_word[SIG_END])
            stage <= 0;
        else
            stage <= stage + 1;
    end
    
    always @(*) begin
        ctrl_word = ctrl_rom[{opcode, stage}];

        if ((opcode == 8'hCA && stage == 4 && !Z) ||   // JZ fail
            (opcode == 8'hC2 && stage == 4 && Z)  ||   // JNZ fail
            (opcode == 8'hFA && stage == 4 && !S))     // JM fail
        begin
            ctrl_word = {1'b1, 46'b0}; // END=1, all else = 0
        end
    end
    
    assign out = ctrl_word[45:0];

endmodule