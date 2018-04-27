__putchar:
LDY #00
LDA (&8E),Y
JSR &FFEE
STA &70
RTS

__getchar:
JSR &FFE0
STA &70
RTS

__osbyte:
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

__fgets:
LDA #0
STA &72
STA &73
__fgets_1:
LDA &73
LDY #3
CMP (&8E),Y
BCC __fgets_2
BNE __fgets_3
LDA &72
LDY #2
CMP (&8E),Y
BCS __fgets_3
__fgets_2:
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
__fgets_4:
JMP __fgets_1
__fgets_3:
RTS

