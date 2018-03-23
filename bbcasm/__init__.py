def asm_to_basic(asm):
    out = "NEW\n"
    start_lines = [
        "FOR opt%=0 TO 2 STEP 2",
        "P%=&E00",
        "SIGN=&70",
        "X2=SIGN+1",
        "M2=X2+1",
        "X1=M2+3",
        "M1=X1+1",
        "E=M1+3",
        "ZZ=E+4",
        "T=ZZ+4",
        "SEXP=T+4",
        "IT=SEXP+4",
        "X=IT+2",
        "Y=X+2",
        "R=Y+2",
        "COL=R+1",
        "1[",
        "OPT opt%",
    ]
    end_lines = [
        "]",
        "NEXT opt%",
        "CALL main",
        "RL=&87",
        "RH=&86",
        "PRINT ~?RH,~?RL",
    ]
    for i, line in enumerate(start_lines + asm.splitlines() + end_lines):
        out += str(i) + " " + line.strip() + "\n"

    return out
