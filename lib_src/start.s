.import main
.export _bbcc_pusha
.export _bbcc_pulla
.export _start

_bbcc_pusha: pha
lda &8E
bne _bbcc_pusha_1
dec &8F
_bbcc_pusha_1:
dec &8E
pla
ldy #00
sta (&8E),Y
rts

_bbcc_pulla: ldy #0
lda (&8E),Y
inc &8E
beq _bbcc_pulla_1
rts
_bbcc_pulla_1:
inc &8F
rts

_start:
lda #&00
sta &8E
lda #&18
sta &8F

jsr main
rts