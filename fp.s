.add   CLC
       LDX #&02    
.add1  LDA M1,X
       ADC M2,X
       STA M1,X
       DEX         
       BPL add1
       RTS         
.md1   ASL SIGN
       JSR abswap
.abswap BIT M1
       BPL abswp1
       JSR fcompl
       INC SIGN    
.abswp1 SEC
.swap  LDX #&04
.swap1 STY E-1,X
       LDA X1-1,X
       LDY X2-1,X
       STY X1-1,X
       STA X2-1,X
       DEX         
       BNE swap1
       RTS

.float LDA #&8E
       STA X1      
       LDA #0      
       STA M1+2
       BEQ norml
.norm1 DEC X1
       ASL M1+2
       ROL M1+1    
       ROL M1
.norml LDA M1
       ASL A
       EOR M1
       BMI rts1
       LDA X1
       BNE norm1
.rts1  RTS

.fsub  JSR fcompl
.swpalg JSR algnsw

.fadd  LDA X2
       CMP X1      
       BNE swpalg
       JSR add
.addend BVC norml
       BVS rtlog
.algnsw BCC swap
.rtar  LDA M1
       ASL A
.rtlog INC X1
       BEQ ovfl
.rtlog1 LDX #&FA
.ror1  LDA #&80
       BCS ror2
       ASL A
.ror2  LSR E+3,X
       ORA E+3,X
       STA E+3,X
       INX         
       BNE ror1
       RTS         

.fmul  JSR md1
       ADC X1      
       JSR md2
       CLC         
.mul1  JSR rtlog1
       BCC mul2
       JSR add
.mul2  DEY
       BPL mul1
.mdend LSR SIGN
.normx BCC norml
.fcompl SEC
       LDX #&03    
.compl1 LDA #&00
       SBC X1,X
       STA X1,X
       DEX         
       BNE compl1
       BEQ addend

.fdiv  JSR md1
       SBC X1      
       JSR md2
.div1  SEC
       LDX #&02
.div2  LDA M2,X
       SBC E,X     
       PHA         
       DEX         
       BPL div2
       LDX #&FD
.div3  PLA
       BCC div4
       STA M2+3,X
.div4  INX
       BNE div3
       ROL M1+2
       ROL M1+1    
       ROL M1
       ASL M2+2
       ROL M2+1    
       ROL M2
       BCS ovfl
       DEY         
       BNE div1
       BEQ mdend
.md2   STX M1+2
       STX M1+1    
       STX M1
       BCS ovchk
       BMI md3
       PLA         
       PLA         
       BCC normx
.md3   EOR #&80
       STA X1      
       LDY #&17
       RTS         
.ovchk BPL md3
.ovfl  BRK
JSR rtar
fix:   LDA X1
       CMP #$8E
       BNE fix-3
rtrn:  RTS
.main LDA #&81
STA X1
LDA #&40
STA M1
LDA #&00
STA M1+1
LDA #&00
LDA #&82
STA X2
LDA #&40
STA M2
LDA #&00
STA M2+1
LDA #&00
STA M2+2
JSR fmul
LDA X1
STA &86
LDA M1
STA &87
RTS