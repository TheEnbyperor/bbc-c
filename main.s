.__putchar
LDY #00
LDA (&8E),Y
JSR &FFEE
STA &70
RTS

.__getchar
JSR &FFE0
STA &70
RTS

.__osbyte
LDA &71
PHA
LDY #02
LDA (&8E),Y
STA &71
LDY #01
LDA (&8E),Y
TAX
LDY #00
LDA (&8E),Y
LDY &71
JSR &FFF4
PLA
STA &71
STA &70
RTS

.__fgets
LDA #0
STA &72
STA &73
.__fgets_1
LDA &73
LDY #3
CMP (&8E),Y
BCC __fgets_2
BNE __fgets_3
LDA &72
LDY #2
CMP (&8E),Y
BCS __fgets_3
.__fgets_2
JSR __getchar
LDA &70
LDY #0
STA (&8E),Y
CLC
LDA (&8E),Y
ADC #1
STA (&8E),Y
LDY #1
LDA (&8E),Y
ADC #0
STA (&8E),Y
INC &72
BNE __fgets_4
INC &73
.__fgets_4
JMP __fgets_1
.__fgets_3
RTS



\ Routines
._bbcc_pusha PHA
LDA &8E
BNE _bbcc_pusha_1
DEC &8F
._bbcc_pusha_1 
DEC &8E
PLA
LDY #00
STA (&8E),Y
RTS
._bbcc_pulla LDY #0
LDA (&8E),Y
INC &8E
BEQ _bbcc_pulla_1
RTS
._bbcc_pulla_1 
INC &8F
RTS

\ Label
._setup_global 

\ Return
RTS

\ Function
._start 

\ Set
LDA #&18
STA &8E
LDA #&00
STA &8F

\ JmpSub
JSR _setup_global

\ CallFunction
JSR __main

\ Return
RTS

\ Function
.__main 
LDA &72
PHA
LDA &73
PHA
LDA &74
PHA
LDA &75
PHA

\ Mult
LDA #&03
STA &72
LDA #&00
STA &73
LDA #&0A
STA &70
LDA #&00
STA &71
LDA #0
STA &74
STA &75
LDX #&10
.__bbcc_00000000 
LSR &71
ROR &70
BCC __bbcc_00000001
CLC
LDA &72
ADC &74
STA &74
LDA &73
ADC &75
STA &75
.__bbcc_00000001 CLC
ASL &72
ROL &73
DEX
BNE __bbcc_00000000

\ Return
LDA &74
STA &70
LDA &75
STA &71
PLA
STA &73
PLA
STA &72
PLA
STA &75
PLA
STA &74
RTS
