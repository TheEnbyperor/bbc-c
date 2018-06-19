.export _start

inst_jump_table_l:
.byte #0(mov_const_reg-1), #0(mov_mem_reg_short-1), #0(mov_mem_reg_long-1), #0(mov_reg_mem_short-1),
      #0(mov_reg_mem_long-1), #0(mov_reg_reg-1), #0(push_reg-1), #0(pop_reg-1), #0(load_address_reg-1),
      #0(add_const_reg-1), #0(add_carry_const_reg-1), #0(add_reg_reg-1), #0(add_carry_reg_reg-1),
      #0(add_mem_reg_short-1), #0(add_carry_mem_reg_short-1), #0(add_mem_reg_long-1), #0(add_carry_mem_reg_long-1),
      #0(sub_const_reg-1), #0(sub_carry_const_reg-1), #0(sub_reg_reg-1), #0(sub_carry_reg_reg-1),
      #0(sub_mem_reg_short-1), #0(sub_carry_mem_reg_short-1), #0(sub_mem_reg_long-1), #0(sub_carry_mem_reg_long-1),
      #0(inc_reg-1), #0(dec_reg-1), #0(and_const_reg-1), #0(and_reg_reg-1), #0(and_mem_reg_short-1),
      #0(and_mem_reg_long-1), #0(or_const_reg-1), #0(or_reg_reg-1), #0(or_mem_reg_short-1), #0(or_mem_reg_long-1),
      #0(xor_const_reg-1), #0(xor_reg_reg-1), #0(xor_mem_reg_short-1), #0(xor_mem_reg_long-1), #0(not_reg-1),
      #0(neg_reg-1), #0(cmp_const_reg-1), #0(cmp_reg_reg-1), #0(cmp_mem_reg_short-1), #0(cmp_mem_reg_long-1),
      #0(call_subroutine-1), #0(call_6502-1)

inst_jump_table_h:
.byte #1(mov_const_reg-1), #1(mov_mem_reg_short-1), #1(mov_mem_reg_long-1), #1(mov_reg_mem_short-1),
      #1(mov_reg_mem_long-1), #1(mov_reg_reg-1), #1(push_reg-1), #1(pop_reg-1), #1(load_address_reg-1),
      #1(add_const_reg-1), #1(add_carry_const_reg-1), #1(add_reg_reg-1), #1(add_carry_reg_reg-1),
      #1(add_mem_reg_short-1), #1(add_carry_mem_reg_short-1), #1(add_mem_reg_long-1), #1(add_carry_mem_reg_long-1),
      #1(sub_const_reg-1), #1(sub_carry_const_reg-1), #1(sub_reg_reg-1), #1(sub_carry_reg_reg-1),
      #1(sub_mem_reg_short-1), #1(sub_carry_mem_reg_short-1), #1(sub_mem_reg_long-1), #1(sub_carry_mem_reg_long-1),
      #1(inc_reg-1), #1(dec_reg-1), #1(and_const_reg-1), #1(and_reg_reg-1), #1(and_mem_reg_short-1),
      #1(and_mem_reg_long-1), #1(or_const_reg-1), #1(or_reg_reg-1), #1(or_mem_reg_short-1), #1(or_mem_reg_long-1),
      #1(xor_const_reg-1), #1(xor_reg_reg-1), #1(xor_mem_reg_short-1), #1(xor_mem_reg_long-1), #1(not_reg-1),
      #1(neg_reg-1), #1(cmp_const_reg-1), #1(cmp_reg_reg-1), #1(cmp_mem_reg_short-1), #1(cmp_mem_reg_long-1),
      #1(call_subroutine-1), #1(call_6502-1)

other_inst_jump_table_l:
.byte #0(set_carry-1), #0(clear_carry-1), #0(return-1)

other_inst_jump_table_h:
.byte #1(set_carry-1), #1(clear_carry-1), #1(return-1)

_start:
\ Load PC
pla
sta &8C
pla
sta &8D

\ Set SP and status register
lda #&00
sta &8A
sta &88
sta &89
lda #&18
sta &8B

\ Run loop
_init_1:
jsr interpret
jmp _init_1

\ Increment PC
inc_pc:
inc &8C
bne _inc_pc
inc &8D
_inc_pc:
rts

interpret:
jsr inc_pc

\ Load first byte of instruction
ldy #0
lda (&8C),Y
jsr inc_pc

\ Test for non register instruction
tax
and #&80
bne other_inst

\ Load jump address
lda inst_jump_table_h,x
pha
lda inst_jump_table_l,x
pha

\ Load register operand
ldy #0
lda (&8C),Y
tay
and #&0F

\ Multiply by 2 for 2 byte registers
asl a
tax

\ Load second register operand
tya
lsr a
lsr a
lsr a
tay

\ Do jump
rts

\ Non register instructions
other_inst:

\ Set top bit to 0
txa
and &7f
tax

\ Load jump address
lda other_inst_jump_table_h,x
pha
lda other_inst_jump_table_l,x
pha

\ Do jump
rts

\ Helper: Load address to scratch register
get_mem_address:
tya
beq _get_mem_absolute
cmp #&01
beq _get_mem_rel_minus
cmp #&02
beq _get_mem_rel_plus
cmp #&03
beq _get_mem_indirect
_get_mem_absolute:
ldy #2
lda (&8C),y
sta &8F
dey
lda (&8C),y
sta &8E
jmp _get_mem_address
_get_mem_rel_minus:
ldy #1
lda &8C
sec
sbc (&8C),y
sta &8E
iny
lda &8D
sbc (&8C),y
sta &8F
jmp _get_mem_address
_get_mem_rel_plus:
ldy #1
lda &8C
clc
adc (&8C),y
sta &8E
iny
lda &8D
adc (&8C),y
sta &8F
jmp _get_mem_address
_get_mem_indirect:
ldy #1
lda (&8C), y
lsr a
lsr a
lsr a
lsr a
php
asl a
tax
lda (&8C), y
and #&0F
plp
bcc _get_mem_indirect_2
ora #&F0
_get_mem_indirect_2:
clc
adc &70,x
sta &8E
iny
lda (&8C), y
adc &71,x
sta &8F
_get_mem_address:
jsr inc_pc
ldy #0
jmp inc_pc

\ Load 16 bit constant value into register
mov_const_reg:
ldy #1
lda (&8C),y
sta &70,x
iny
lda (&8C),y
sta &71,x
jmp inc_pc

\ Moves register to register
mov_reg_reg:
lda &70,x
sta &0071,y
lda &71,x
sta &0070,y
rts

\ Load a 8 bit value from memory into a register
mov_mem_reg_short:
jsr get_mem_address
lda (&8E),y
sta &70,x
sty &71,x
rts

\ Load a 16 bit value from memory into a register
mov_mem_reg_long:
jsr mov_mem_reg_short
iny
lda (&8E),y
sta &71,x
rts

\ Load a 8 bit value from register into a memory
mov_reg_mem_short:
jsr get_mem_address
lda &70, x
sta (&8E), y
rts

\ Load a 16 bit value from register into a memory
mov_reg_mem_long:
jsr mov_reg_mem_short
lda &71,x
iny
sta (&8E), y
rts

\ Push register onto stack
push_reg:
lda &8A
sec
sbc #2
sta &8A
bcs _push_reg
dec &8B
_push_reg:
lda &70,x
ldy #0
sta (&8A),y
lda &71,x
iny
sta (&8A),y
rts

\ Pop value off stack to register
pop_reg:
ldy #1
lda (&8A),y
sta &71,x
dey
lda (&8A),y
sta &70,x
inc &8A
inc &8A
bne _push_reg
inc &8B
_push_reg:
rts

\ Load address into register
load_address_reg:
jsr get_mem_address
lda &8E
sta &70,x
lda &8F
sta &71,x
rts

\ Set carry from status flag
load_carry_status:
lda &88
lsr a
rts

\ Set carry flag in status to 6502 carry
set_carry_status:
lda &88
and &FE
sta &88
lda #0
rol a
ora &88
sta &88
rts

set_sign_zero_from_reg:
lda &88
and #&F9
tay
lda &71,x
php
asl a
bcc _set_sign_zero_from_reg_not_minus
tya
ora #&04
tay
_set_sign_zero_from_reg_not_minus:
plp
bne _set_sign_zero_from_reg_not_zero
lda &70,x
bne _set_sign_zero_from_reg_not_zero
tya
ora #&02
tay
_set_sign_zero_from_reg_not_zero:
sty &88
rts

\ Sets the carry flag
set_carry:
sec
bcs set_carry_status

\ Clears the carry flag
clear_carry:
clc
bcc set_carry_status

\ Add constant to register
add_const_reg:
clc
bcc _add_const_reg
\ Add with carry
add_carry_const_reg:
jsr load_carry_status
_add_const_reg:
lda &70,x
ldy #1
adc (&8C),y
sta &70,x
iny
lda &71,x
adc (&8C),y
sta &71,x
jsr set_carry_status
jsr set_sign_zero_from_reg
jmp inc_pc

\ Add register to register
add_reg_reg:
clc
bcc _add_reg_reg
\ Add with carry
add_carry_reg_reg:
jsr load_carry_status
_add_reg_reg:
lda &0070,y
adc &70,x
sta &70,x
lda &0071,y
adc &71,x
sta &71,x
jsr set_carry_status
jmp set_sign_zero_from_reg

\ Helper for memory to register add
add_mem_reg_start:
jsr get_mem_address
lda (&8E),y
adc &70,x
sta &70,x

\ Add 8 bit memory to register
add_mem_reg_short:
clc
bcc _add_mem_reg_short
\ Add with carry
add_carry_mem_reg_short:
jsr load_carry_status
_add_mem_reg_short:
jsr add_mem_reg_start
lda #0
adc &71,x
sta &71,x
jsr set_carry_status
jmp set_sign_zero_from_reg

\ Add 16 bit memory to register
add_mem_reg_long:
clc
bcc _add_mem_reg_long
\ Add with carry
add_carry_mem_reg_long:
jsr load_carry_status
_add_mem_reg_long:
jsr add_mem_reg_start
iny
lda (&8E),y
adc &71,x
sta &71,x
jsr set_carry_status
jmp set_sign_zero_from_reg

\ Subtract constant from register
sub_const_reg:
sec
bcc _sub_const_reg
\ Subtract with carry
sub_carry_const_reg:
jsr load_carry_status
_sub_const_reg:
lda &70,x
ldy #1
sbc (&8C),y
sta &70,x
iny
lda &71,x
sbc (&8C),y
sta &71,x
jsr set_carry_status
jsr set_sign_zero_from_reg
jmp inc_pc

\ Compare constant and register
cmp_const_reg:
sec
lda &70,x
ldy #1
sbc (&8C),y
sta &8E
iny
lda &71,x
sbc (&8C),y
sta &8F
jsr set_carry_status
ldx #15
jsr set_sign_zero_from_reg
jmp inc_pc

\ Subtract register from register
sub_reg_reg:
sec
bcc _sub_reg_reg
\ Add with carry
sub_carry_reg_reg:
jsr load_carry_status
_sub_reg_reg:
lda &0070,y
sbc &70,x
sta &70,x
lda &0071,y
sbc &71,x
sta &70,x
jsr set_carry_status
jmp set_sign_zero_from_reg

\ Compare register and register
cmp_reg_reg:
sec
lda &0070,y
sbc &70,x
sta &8E
lda &0071,y
sbc &71,x
sta &8F
jsr set_carry_status
ldx #15
jmp set_sign_zero_from_reg

\ Helper for memory from register subtract
sub_mem_reg_start:
jsr get_mem_address
lda &70,x
sec
sbc (&8E),y

\ Subtract 8 bit memory from register
sub_mem_reg_short:
sec
bcc _sub_mem_reg_short
\ Add with carry
sub_carry_mem_reg_short:
jsr load_carry_status
_sub_mem_reg_short:
jsr sub_mem_reg_start
sta &70,x
lda &71,x
sbc #0
sta &71,x
jsr set_carry_status
jmp set_sign_zero_from_reg

\ Compare 8 bit memory and register
cmp_mem_reg_short:
sec
jsr sub_mem_reg_start
sta &8E
lda &71,x
sbc #0
sta #8F
jsr set_carry_status
ldx #15
jmp set_sign_zero_from_reg

\ Subtract 16 bit memory from register
sub_mem_reg_long:
sec
bcc _sub_mem_reg_long
\ Add with carry
sub_carry_mem_reg_long:
jsr load_carry_status
_sub_mem_reg_long:
jsr sub_mem_reg_start
sta &70,x
iny
lda &71,x
sbc (&8E),y
sta &71,x
jsr set_carry_status
jmp set_sign_zero_from_reg

\ Compare 16 bit memory and register
cmp_mem_reg_long:
sec
jsr sub_mem_reg_start
sta &8E
iny
lda (&8E),y
sbc &71,x
sta &8F
jsr set_carry_status
ldx #15
jmp set_sign_zero_from_reg

\ Increment register
inc_reg:
inc &70,x
bne _inc_reg
inc &71,x
_inc_reg:
jmp set_sign_zero_from_reg

\ Decrement register
dec_reg:
lda &70,x
bne _inc_reg
dec &71,x
_inc_reg:
dec &70,x
jmp set_sign_zero_from_reg

\ Logical and constant and register
and_const_reg:
lda &70,x
ldy #1
and (&8C),y
sta &70,x
iny
lda &71,x
and (&8C),y
sta &71,x
jsr set_sign_zero_from_reg
jsr clear_carry
jmp inc_pc

\ Logical and register and register
and_reg_reg:
lda &0070,y
and &70,x
sta &70,x
lda &0071,y
and &71,x
sta &71,x
jsr set_sign_zero_from_reg
jmp clear_carry

\ Helper for memory and register logical and
and_mem_reg_start:
jsr get_mem_address
lda (&8E),y
and &70,x
sta &70,x
rts

\ 8 bit logical and memory anh register
and_mem_reg_short:
jsr and_mem_reg_start
lda #0
sta &71,x
jsr set_sign_zero_from_reg
jmp clear_carry

\ 16 bit logical and memory and register
and_mem_reg_long:
jsr and_mem_reg_start
iny
lda (&8E),y
and &71,x
sta &71,x
jsr set_sign_zero_from_reg
jmp clear_carry

\ Logical or constant and register
or_const_reg:
lda &70,x
ldy #1
ora (&8C),y
sta &70,x
iny
lda &71,x
ora (&8C),y
sta &71,x
jsr set_sign_zero_from_reg
jsr clear_carry
jmp inc_pc

\ Logical or register and register
or_reg_reg:
lda &0070,y
ora &70,x
sta &70,x
lda &0071,y
ora &71,x
sta &71,x
jsr set_sign_zero_from_reg
jmp clear_carry

\ Helper for memory and register logical or
or_mem_reg_start:
jsr get_mem_address
lda (&8E),y
ora &70,x
sta &70,x
iny
lda (&8E),y
rts

\ 8 bit logical or memory and register
or_mem_reg_short:
jsr or_mem_reg_start
sta &71,x
rts

\ 16 bit logical or memory and register
or_mem_reg_long:
jsr or_mem_reg_start
ora &71,x
sta &71,x
jsr set_sign_zero_from_reg
jmp clear_carry

\ Logical xor constant and register
xor_const_reg:
lda &70,x
ldy #1
eor (&8C),y
sta &70,x
iny
lda &71,x
eor (&8C),y
sta &71,x
jsr set_sign_zero_from_reg
jsr clear_carry
jmp inc_pc

\ Logical xor register and register
xor_reg_reg:
lda &0070,y
eor &70,x
sta &70,x
lda &0071,y
eor &71,x
sta &71,x
jsr set_sign_zero_from_reg
jmp clear_carry

\ Helper for memory and register logical xor
xor_mem_reg_start:
jsr get_mem_address
lda (&8E),y
eor &70,x
sta &70,x
iny
lda (&8E),y
rts

\ 8 bit logical xor memory and register
xor_mem_reg_short:
jsr xor_mem_reg_start
eor #0
sta &71,x
jsr set_sign_zero_from_reg
jmp clear_carry

\ 16 bit logical xor memory and register
xor_mem_reg_long:
jsr xor_mem_reg_start
eor &71,x
sta &71,x
jsr set_sign_zero_from_reg
jmp clear_carry

\ Logical not register
not_reg:
lda &70,x
eor #&ff
sta &70,x
lda &71,x
eor #&ff
sta &71,x
rts

\ 2's compliment negate register
neg_reg:
lda &70,x
eor #&ff
clc
adc #1
sta &70,x
lda &71,x
eor #&ff
adc #0
sta &71,x
jmp set_sign_zero_from_reg

call_subroutine:
ldx #14
jsr push_reg
jsr get_mem_address
lda &8E
sec
sbc #1
sta &8C
iny
lda &8F
sbc #0
sta &8D
rts

call_6502:
ldy #0
lda (&8C), y
pha
iny
lda (&8C), y
pha
rts

return:
ldx #14
jmp pop_reg