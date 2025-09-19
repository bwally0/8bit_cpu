# 8bit_cpu

### Instruction Set Architecture (ISA)
| Opcode (Hex) | Mnemonic | Description | Operation | Cycles |
|--------------|----------|-------------|-----------|--------|
| `1X`         | LDA      | Load REG A with the value from memory at address `X` (lower 4 bits). | `A <= RAM[X]` | 4 |
| `2X`         | ADD      | Add the value from memory at address `X` to REG A, store result in A. | `A <= A + RAM[X]` | 5 |
| `3X`         | SUB      | Subtract the value from memory at address `X` from REG A, store result in A. | `A <= A - RAM[X]` | 5 |
| `E0`         | OUT      | Copy the value in REG A to the output register. | `OUT_REG <= A` | 3 |
| `F0`         | HLT      | Halt the CPU. | `CPU_CLK <= 0` | 3 |

### Sample Program
`program.hex`
```
$0 | 1E // LDA [$E]
$1 | 2F // ADD [$F]
$2 | E0 // OUT
$3 | F0 // HLT
$4 | 00 // unused
$5 | 00 // unused
$6 | 00 // unused
$7 | 00 // unused
$8 | 00 // unused
$9 | 00 // unused
$A | 00 // unused
$B | 00 // unused
$C | 00 // unused
$D | 00 // unused
$E | 05 // data: 5
$F | 0A // data: 10
```
