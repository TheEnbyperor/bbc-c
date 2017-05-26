def asm_to_basic(asm):
    out = """NEW
10 FOR opt%=0 TO 2 STEP 2
20 P%=&E00
30 [
"""
    for i, line in enumerate(asm.splitlines()):
        out += (i * 10) + 40  + " " + line + "\n"
    out += """]
NEXT opt%
CALL main
RL=&87
RH=&86
PRINT ~?RH,~?RL
"""
    return out