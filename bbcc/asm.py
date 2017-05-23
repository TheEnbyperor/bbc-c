class ASM:
    num1 = 0x8F
    num2 = 0x8D
    result = 0x8B
    ret = 0x87

    def __init__(self):
        self.asm = """NEW
10 FOR opt%=0 TO 2 STEP 2
20 P%=&E00
30 [
40 OPT opt%
50 .mul LDA #0
60 STA &""" + self._to_hex(self.result-2) + """
70 STA &""" + self._to_hex(self.result-3) + """
80 LDX #&10 
90 .mul1 LSR &""" + self._to_hex(self.num1-1) + """ 
100 ROR &""" + self._to_hex(self.num1) + """
110 BCC mul2 
120 LDA &""" + self._to_hex(self.result-2) + """
130 CLC
140 ADC &""" + self._to_hex(self.num2) + """
150 STA &""" + self._to_hex(self.result-2) + """
160 LDA &""" + self._to_hex(self.result-3) + """
170 ADC &""" + self._to_hex(self.num2-1) + """
180 .mul2 ROR A 
190 STA &""" + self._to_hex(self.result-3) + """ 
200 ROR &""" + self._to_hex(self.result-2) + """
210 ROR &""" + self._to_hex(self.result-1) + """
220 ROR &""" + self._to_hex(self.result) + """
230 DEX
240 BNE mul1
245 JSR movres
250 RTS
260 .div LDA #0
270 STA &""" + self._to_hex(self.result) + """
280 STA &""" + self._to_hex(self.result-1) + """
290 LDX #16
300 .div1 ASL &""" + self._to_hex(self.num1) + """
310 ROL &""" + self._to_hex(self.num1-1) + """ 
320 ROL &""" + self._to_hex(self.result) + """
330 ROL &""" + self._to_hex(self.result-1) + """
340 LDA &""" + self._to_hex(self.result) + """
350 SEC
360 SBC &""" + self._to_hex(self.num2) + """
370 TAY
380 LDA &""" + self._to_hex(self.result-1) + """
390 SBC &""" + self._to_hex(self.num2-1) + """
400 BCC div2
410 STA &""" + self._to_hex(self.result-1) + """
420 STY &""" + self._to_hex(self.result) + """
430 INC &""" + self._to_hex(self.num1) + """
440 .div2 DEX
450 BNE div1
560 RTS
570 .add CLC
580 LDA &""" + self._to_hex(self.num1) + """
590 ADC &""" + self._to_hex(self.num2) + """
600 STA &""" + self._to_hex(self.result) + """
610 LDA &""" + self._to_hex(self.num1-1) + """
620 ADC &""" + self._to_hex(self.num2-1) + """
630 STA &""" + self._to_hex(self.result-1) + """
635 JSR movres
640 RTS
650 .sub SEC
660 LDA &""" + self._to_hex(self.num1) + """
670 SBC &""" + self._to_hex(self.num2) + """
680 STA &""" + self._to_hex(self.result) + """
690 LDA &""" + self._to_hex(self.num1-1) + """
700 SBC &""" + self._to_hex(self.num2-1) + """
710 STA &""" + self._to_hex(self.result-1) + """
715 JSR movres
720 RTS
740 .movnum LDA &""" + self._to_hex(self.num2) + """
750 STA &""" + self._to_hex(self.num1) + """
760 LDA &""" + self._to_hex(self.num2-1) + """
770 STA &""" + self._to_hex(self.num1-1) + """
780 RTS
790 .movres LDA &""" + self._to_hex(self.result) + """
800 STA &""" + self._to_hex(self.num2) + """
810 LDA &""" + self._to_hex(self.result-1) + """
820 STA &""" + self._to_hex(self.num2-1) + """
830 RTS
840 .neg LDA &""" + self._to_hex(self.num2) + """
850 EOR #&FF
860 STA &""" + self._to_hex(self.num2) + """
870 LDA &""" + self._to_hex(self.num2-1) + """
880 EOR #&FF
890 STA &""" + self._to_hex(self.num2-1) + """
900 LDA #0
910 STA &""" + self._to_hex(self.num1-1) + """
900 LDA #1
910 STA &""" + self._to_hex(self.num1) + """
920 JSR add
930 JSR movres
940 RTS
950 .reset LDA #0
960 STA &""" + self._to_hex(self.result) + """
970 STA &""" + self._to_hex(self.result-1) + """
980 STA &""" + self._to_hex(self.num1) + """
990 STA &""" + self._to_hex(self.num1-1) + """
1000 STA &""" + self._to_hex(self.num2) + """
1010 STA &""" + self._to_hex(self.num2-1) + """
1020 RTS
"""
        self.line = 1030

    @staticmethod
    def _to_hex(num):
        return ('%02x' % num).upper()

    def add_inst(self, isnt, op="", label=""):
        self.asm += str(self.line) + " "
        if label != "":
            self.asm += "." + label
        self.asm += isnt.upper()
        if op != "":
            self.asm += " " + str(op)
        self.asm += "\n"
        self.line += 10

    def get_asm(self):
        self.add_inst("]")
        self.add_inst("NEXT", "opt%")
        self.add_inst("CALL", "main")
        self.add_inst("RL=&" + self._to_hex(self.ret))
        self.add_inst("RH=&" + self._to_hex(self.ret-1))
        self.add_inst("PRINT", "~?RH,~?RL")
        asm = self.asm
        asm += "RUN\n"
        return asm
