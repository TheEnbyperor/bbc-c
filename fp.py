import bbcasm

with open("brot.s", "r") as f:
    lines = "".join(f.readlines())

basic = bbcasm.asm_to_basic(lines)

print(basic)
