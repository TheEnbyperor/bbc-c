def asm_to_basic(asm):
    out = "NEW\n"
    start_lines = [
        "FOR opt%=0 TO 2 STEP 2",
        "P%=&E00",
        "[",
        "OPT opt%",
    ]
    end_lines = [
        "]",
        "NEXT opt%",
        "PRINT ~_start",
        "CALL _start",
        "RH=&70",
        "RL=&71",
        "PRINT ~?RH,~?RL",
    ]
    for i, line in enumerate(start_lines + asm.splitlines() + end_lines):
        out += str(i) + " " + line.strip() + "\n"

    return out
