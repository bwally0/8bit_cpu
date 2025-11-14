MEM_SIZE = 65536

with open("program.hex", "w") as f:
    for _ in range(MEM_SIZE):
        f.write("00\n")
