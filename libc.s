.__putchar
LDY #01
LDA (&8E),Y
JSR &FFEE
STA &71
LDA #00
STA &70
RTS