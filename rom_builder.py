import openpyxl

signals = [
    "END",
    "HLT",
    "PC_EN",
    "MDR_EN",
    "A_EN",
    "B_EN",
    "C_EN",
    "TMP_EN",
    "ALU_EN",
    "SP_EN",
    "IO_EN",
    "PC_LOAD",
    "PC_INR",
    "IR_LOAD",
    "A_LOAD",
    "A_INR",
    "A_DCR",
    "B_LOAD",
    "B_INR",
    "B_DCR",
    "C_LOAD",
    "C_INR",
    "C_DCR",
    "TMP_LOAD",
    "TMP_INR",
    "TMP_DCR",
    "OUT_LOAD",
    "SP_LOAD",
    "SP_INR",
    "SP_DCR",
    "MAR_LOAD",
    "MDR_LOADB",
    "MDR_LOADL",
    "MDR_LOADH",
    "RAM_WRITE",
    "ALU_OP3",
    "ALU_OP2",
    "ALU_OP1",
    "ALU_OP0",
    "FLAG_LOAD",
    "IO_LOAD",
    "UNUSED5",
    "UNUSED4",
    "UNUSED3",
    "UNUSED2",
    "UNUSED1",
    "UNUSED0",
]

wb = openpyxl.load_workbook("control_words_blank.xlsx", data_only=True)
ws = wb.active

with open("ctrl_rom.bin", "w") as f:
    for row in ws.iter_rows(min_row=2, values_only=True):  # skip header
        opcode = row[0]
        stage = row[5]
        if opcode == "" or stage is None:
            continue

        sig_bits = [
            str(int(val)) if val not in (None, "") else "0"
            for val in row[6 : 6 + len(signals)]
        ]

        ctrl_word = "".join(sig_bits)

        f.write(ctrl_word + "\n")

print("ctrl_rom.bin generated.")
