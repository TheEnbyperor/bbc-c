def asm_to_basic(asm):
    asm = asm.splitlines()
    out = "NEW\n"
    start_lines = [
        "DIM MC% {}".format(len(asm)*3),
        "FOR opt%=0 TO 2 STEP 2",
        "P%=MC%",
        "[",
        "OPT opt%",
    ]
    end_lines = [
        "]",
        "NEXT opt%",
        "PRINT ~_start",
        "CALL _start",
        "RH=&71",
        "RL=&70",
        "PRINT ~?RH,~?RL",
    ]
    for i, line in enumerate(start_lines + asm + end_lines):
        out += str(i) + " " + line.strip() + "\n"

    return out
