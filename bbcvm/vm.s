.export _start_vm

// ZP Locations
// $8e-f: Indirect for extended memory
// $8a-d: Temporary store for addresses
// $86-9: Temporary store 2 for addresses

inst_jump_table_l:
.byte #0(mov_const_reg-1)

inst_jump_table_h:
.byte #1(mov_const_reg-1)

other_inst_jump_table_l:
.byte #0(set_carry-1), #0(clear_carry-1), #0(return-1), #0(exit_vm-1), #0(halt_and_catch_fire-1)

other_inst_jump_table_h:
.byte #1(set_carry-1), #1(clear_carry-1), #1(return-1), #1(exit_vm-1), #1(halt_and_catch_fire-1)

_r_0:      .byte #0,#0,#0,#0
_r_1:      .byte #0,#0,#0,#0
_r_2:      .byte #0,#0,#0,#0
_r_3:      .byte #0,#0,#0,#0
_r_4:      .byte #0,#0,#0,#0
_r_5:      .byte #0,#0,#0,#0
_r_6:      .byte #0,#0,#0,#0
_r_7:      .byte #0,#0,#0,#0
_r_8:      .byte #0,#0,#0,#0
_r_9:      .byte #0,#0,#0,#0
_r_10:     .byte #0,#0,#0,#0
_r_11:     .byte #0,#0,#0,#0
_r_12:     .byte #0,#0,#0,#0
_r_status: .byte #0,#0,#0,#0
_r_stack:  .byte #0,#0,#0,#0
_r_pc:     .byte #0,#0,#0,#0
_r_temp:   .byte #0,#0,#0,#0

_start_vm:
// Set PC and status register
lda #$00
sta 0(_r_status)
sta 1(_r_status)
sta 2(_r_status)
sta 3(_r_status)
sta 0(_r_pc)
sta 1(_r_pc)
sta 2(_r_pc)
sta 3(_r_pc)
// Set ZP for memory access
lda #$fd
sta $8f

// Run loop
_init_1:
jsr interpret
jmp _init_1

// Increment PC
inc_pc:
inc 0(_r_pc)
bne _inc_pc
inc 1(_r_pc)
bne _inc_pc
inc 2(_r_pc)
bne _inc_pc
inc 3(_r_pc)
_inc_pc:
rts

inc_pc_4:
jsr inc_pc
jsr inc_pc
jsr inc_pc
jmp inc_pc

_load_offset: .byte #0
_load_byte_pc:
clc
sty _load_offset
lda 0(_r_pc)
adc _load_offset
sta $8e
lda 1(_r_pc)
adc #0
sta $FC00
lda 2(_r_pc)
adc #0
sta $FC01
lda 3(_r_pc)
adc #0
sta $FC02

_load_byte:
ldy #0
lda ($8e),y
rts

_save_byte:
ldy #0
pla
sta ($8e),y
rts

_save_byte_temp:
pha
sec
php
bcs _load_byte_temp_1
_load_byte_temp:
clc
php
_load_byte_temp_1:
clc
sty _load_offset
lda $8a
adc _load_offset
sta $8e
lda $8b
adc #0
sta $FC00
lda $8c
adc #0
sta $FC01
lda $8d
adc #0
sta $FC02
plp
bcs _load_byte_temp_2
jmp _load_byte
_load_byte_temp_2:
jmp _save_byte

_save_byte_temp_spot_2:
pha
sec
php
bcs _load_byte_temp_spot_2_1
_load_byte_temp_spot_2:
clc
php
_load_byte_temp_spot_2_1:
clc
sty _load_offset
lda $86
adc _load_offset
sta $8e
lda $87
adc #0
sta $FC00
lda $88
adc #0
sta $FC01
lda $89
adc #0
sta $FC02
plp
bcs _load_byte_temp_spot_2_2
jmp _load_byte
_load_byte_temp_spot_2_2:
jmp _save_byte

interpret:
jsr inc_pc

// Load first byte of instruction
jsr _load_byte_pc
jsr inc_pc

// Test for non register instruction
tax
and #$80
bne other_inst

// Load jump address
lda inst_jump_table_h,x
pha
lda inst_jump_table_l,x
pha

// Load register operand
jsr _load_byte_pc
tay
and #$0F

// Multiply by 4 for 4 byte registers
asl a
asl a
tax

// Load second register operand
tya
and #$F0
lsr a
lsr a
tay

// Do jump
rts

// Non register instructions
other_inst:

// Set top bit to 0
txa
and #$7f
tax

// Load jump address
lda other_inst_jump_table_h,x
pha
lda other_inst_jump_table_l,x
pha

// Do jump
rts

// Helper: Load address to scratch register
_get_mem_address_temp_1: .byte #0
_get_mem_address_temp_2: .byte #0
_get_mem_address_temp_3: .byte #0
_get_mem_address_temp_4: .byte #0
get_mem_address:
tya
lsr a
lsr a
beq _get_mem_absolute
cmp #$01
beq _get_mem_rel_minus
cmp #$02
beq _get_mem_rel_plus
jmp _get_mem_indirect
_get_mem_absolute:
ldy #1
jsr _load_byte_pc
sta $8a
iny
jsr _load_byte_pc
sta $8b
iny
jsr _load_byte_pc
sta $8c
iny
jsr _load_byte_pc
sta $8d
jmp _get_mem_address
_get_mem_rel_minus:
jsr inc_pc
ldy #0
lda _load_byte_pc
sta _get_mem_address_temp_1
lda 0(_r_pc)
sec
sbc _get_mem_address_temp_1
sta $8a
iny
lda _load_byte_pc
sta _get_mem_address_temp_1
lda 1(_r_pc)
sbc _get_mem_address_temp_1
sta $8b
iny
lda _load_byte_pc
sta _get_mem_address_temp_1
lda 2(_r_pc)
sbc _get_mem_address_temp_1
sta $8c
iny
lda _load_byte_pc
sta _get_mem_address_temp_1
lda 3(_r_pc)
sbc _get_mem_address_temp_1
sta $8d
jmp _get_mem_address_2
_get_mem_rel_plus:
jsr inc_pc
ldy #0
lda _load_byte_pc
sta _get_mem_address_temp_1
lda 0(_r_pc)
clc
adc _get_mem_address_temp_1
sta $8a
iny
lda _load_byte_pc
sta _get_mem_address_temp_1
lda 1(_r_pc)
adc _get_mem_address_temp_1
sta $8b
iny
lda _load_byte_pc
sta _get_mem_address_temp_1
lda 2(_r_pc)
adc _get_mem_address_temp_1
sta $8c
iny
lda _load_byte_pc
sta _get_mem_address_temp_1
lda 3(_r_pc)
adc _get_mem_address_temp_1
sta $8d
jmp _get_mem_address_2
_get_mem_indirect:
txa
pha
ldy #1
jsr _load_byte_pc
and #$F0
lsr a
lsr a
lsr a
tax
jsr _load_byte_pc
and #$0F
sta _get_mem_address_temp_1
iny
jsr _load_byte_pc
sta _get_mem_address_temp_2
iny
jsr _load_byte_pc
sta _get_mem_address_temp_3
iny
jsr _load_byte_pc
sta _get_mem_address_temp_4
ldy #4
_get_mem_indirect_loop:
asl _get_mem_address_temp_4
rol _get_mem_address_temp_3
rol _get_mem_address_temp_2
rol _get_mem_address_temp_1
dey
bne _get_mem_indirect_loop
lda _get_mem_address_temp_4
and #$08
beq _get_mem_indirect_2
lda _get_mem_address_temp_4
ora #$F0
sta _get_mem_address_temp_4
_get_mem_indirect_2:
clc
lda 0(_r_0),x
adc _get_mem_address_temp_1
sta $8a
lda 1(_r_0),x
adc _get_mem_address_temp_2
sta $8b
lda 2(_r_0),x
adc _get_mem_address_temp_3
sta $8c
lda 3(_r_0),x
adc _get_mem_address_temp_4
sta $8d
pla
tax
_get_mem_address:
jsr inc_pc
_get_mem_address_2:
ldy #0
jsr inc_pc
jsr inc_pc
jmp inc_pc

dec_mem_address:
lda $8a
bne _dec_mem_address_1
lda $8b
bne _dec_mem_address_2
lda $8c
bne _dec_mem_address_3
dec $8d
_dec_mem_address_3:
dec $8c
_dec_mem_address_2:
dec $8b
_dec_mem_address_1:
dec $8a
rts

// Load 32 bit constant value into register
mov_const_reg:
ldy #1
jsr _load_byte_pc
sta 0(_r_0),x
iny
jsr _load_byte_pc
sta 1(_r_0),x
iny
jsr _load_byte_pc
sta 2(_r_0),x
iny
jsr _load_byte_pc
sta 3(_r_0),x
jmp inc_pc_4

// Moves register to register
mov_reg_reg:
lda 0(_r_0),x
sta 0(_r_0),y
lda 1(_r_0),x
sta 1(_r_0),y
lda 2(_r_0),x
sta 2(_r_0),y
lda 3(_r_0),x
sta 3(_r_0),y
rts

// Load a 8 bit value from memory into a register
mov_mem_reg_short:
jsr get_mem_address
jsr _load_byte_temp
sta 0(_r_0),x
tya
sta 1(_r_0),x
sta 2(_r_0),x
sta 3(_r_0),x
rts

// Load a 16 bit value from memory into a register
mov_mem_reg_long:
jsr mov_mem_reg_short
iny
jsr _load_byte_temp
sta 1(_r_0),x
dey
tya
sta 2(_r_0),x
sta 3(_r_0),x
rts

// Load a 32 bit value from memory into a register
mov_mem_reg_double:
jsr mov_mem_reg_long
iny
jsr _load_byte_temp
sta 2(_r_0),x
iny
jsr _load_byte_temp
sta 3(_r_0),x
rts

// Load a 8 bit value from register into a memory
mov_reg_mem_short:
jsr get_mem_address
lda 0(_r_0),x
jsr _save_byte_temp
rts

// Load a 16 bit value from register into a memory
mov_reg_mem_long:
jsr mov_reg_mem_short
lda 1(_r_0),x
iny
jsr _save_byte_temp
rts

// Load a 32 bit value from register into a memory
mov_reg_mem_double:
jsr mov_reg_mem_long
lda 2(_r_0),x
iny
jsr _save_byte_temp
lda 3(_r_0),x
iny
jsr _save_byte_temp
rts

push_start:
lda 0(_r_stack)
bne _push_start_1
lda 1(_r_stack)
bne _push_start_2
lda 2(_r_stack)
bne _push_start_3
dec 3(_r_stack)
_push_start_3:
dec 2(_r_stack)
_push_start_2:
dec 1(_r_stack)
_push_start_1:
dec 0(_r_stack)
jmp pop_start

// Push register onto stack
push_reg:
jsr push_start
lda 0(_r_0),x
ldy #0
jsr _save_byte_temp_spot_2
lda 1(_r_0),x
iny
jsr _save_byte_temp_spot_2
lda 2(_r_0),x
iny
jsr _save_byte_temp_spot_2
lda 3(_r_0),x
iny
jsr _save_byte_temp_spot_2
rts

// Push 32 bit memory location onto stack
push_mem:
jsr push_start
jsr get_mem_address
jsr _load_byte_temp
jsr _save_byte_temp_spot_2
iny
jsr _load_byte_temp
jsr _save_byte_temp_spot_2
iny
jsr _load_byte_temp
jsr _save_byte_temp_spot_2
iny
jsr _load_byte_temp
jsr _save_byte_temp_spot_2
rts

pop_start:
lda 0(_r_stack)
sta $86
lda 1(_r_stack)
sta $87
lda 2(_r_stack)
sta $88
lda 3(_r_stack)
sta $89
rts

pop_end:
inc 0(_r_stack)
bne _pop_end
inc 1(_r_stack)
bne _pop_end
inc 2(_r_stack)
bne _pop_end
inc 3(_r_stack)
_pop_end:
rts

// Pop value off stack into register
pop_reg:
jsr pop_start
ldy #0
jsr _load_byte_temp_spot_2
sta 0(_r_0),x
iny
jsr _load_byte_temp_spot_2
sta 1(_r_0),x
iny
jsr _load_byte_temp_spot_2
sta 2(_r_0),x
iny
jsr _load_byte_temp_spot_2
sta 3(_r_0),x
jmp pop_end

// Pop 32 bit value off stack into memory
pop_mem:
jsr pop_start
jsr get_mem_address
jsr _load_byte_temp_spot_2
jsr _save_byte_temp
iny
jsr _load_byte_temp_spot_2
jsr _save_byte_temp
iny
jsr _load_byte_temp_spot_2
jsr _save_byte_temp
iny
jsr _load_byte_temp_spot_2
jsr _save_byte_temp
jmp pop_end

// Load address that would be read from into register
load_address_reg:
jsr get_mem_address
lda $8a
sta 0(_r_0),x
lda $8b
sta 1(_r_0),x
lda $8c
sta 2(_r_0),x
lda $8d
sta 3(_r_0),x
rts

// Set carry from status flag
load_carry_status:
lda 0(_r_status)
lsr a
rts

// Set carry and overflow flag in status to 6502 carry and overflow
set_carry_status:
lda 0(_r_status)
and #$F6
sta 0(_r_status)
lda #0
rol a
ora 0(_r_status)
bvc _set_carry_status
ora #$08
_set_carry_status:
sta 0(_r_status)
rts

set_sign_zero_from_reg:
lda 0(_r_status)
and #$F9
tay
lda 3(_r_0),x
php
asl a
bcc _set_sign_zero_from_reg_not_minus
tya
ora #$04
tay
_set_sign_zero_from_reg_not_minus:
plp
bne _set_sign_zero_from_reg_not_zero
lda 2(_r_0),x
bne _set_sign_zero_from_reg_not_zero
lda 1(_r_0),x
bne _set_sign_zero_from_reg_not_zero
lda 0(_r_0),x
bne _set_sign_zero_from_reg_not_zero
tya
ora #$02
tay
_set_sign_zero_from_reg_not_zero:
sty 0(_r_status)
rts

// Sets the carry flag
set_carry:
sec
bcs set_carry_status

// Clears the carry flag
clear_carry:
clc
bcc set_carry_status

// Add constant to register
add_const_reg:
clc
bcc _add_const_reg
// Add with carry
add_carry_const_reg:
jsr load_carry_status
_add_const_reg:
ldy #1
jsr _load_byte_pc
adc 0(_r_0),x
sta 0(_r_0),x
iny
jsr _load_byte_pc
adc 1(_r_0),x
sta 1(_r_0),x
iny
jsr _load_byte_pc
adc 2(_r_0),x
sta 2(_r_0),x
iny
jsr _load_byte_pc
adc 3(_r_0),x
sta 3(_r_0),x
jsr set_carry_status
jsr set_sign_zero_from_reg
jmp inc_pc_4

// Add register to register
add_reg_reg:
clc
bcc _add_reg_reg
// Add with carry
add_carry_reg_reg:
jsr load_carry_status
_add_reg_reg:
lda 0(_r_0),y
adc 0(_r_0),x
sta 0(_r_0),y
lda 1(_r_0),y
adc 1(_r_0),x
sta 1(_r_0),y
lda 2(_r_0),y
adc 2(_r_0),x
sta 2(_r_0),y
lda 3(_r_0),y
adc 3(_r_0),x
sta 3(_r_0),y
jsr set_carry_status
jmp set_sign_zero_from_reg

// Helper for memory to register add
add_mem_reg_start:
jsr get_mem_address
jsr _load_byte_temp
adc 0(_r_0),x
sta 0(_r_0),x
rts

add_mem_reg_start_2:
jsr add_mem_reg_start
iny
jsr _load_byte_temp
adc 1(_r_0),x
sta 1(_r_0),x
rts

// Add 8 bit memory to register
add_mem_reg_short:
clc
bcc _add_mem_reg_short
// Add with carry
add_carry_mem_reg_short:
jsr load_carry_status
_add_mem_reg_short:
jsr add_mem_reg_start
lda #0
adc 1(_r_0),x
sta 1(_r_0),x
lda #0
adc 2(_r_0),x
sta 2(_r_0),x
lda #0
adc 3(_r_0),x
sta 3(_r_0),x
jsr set_carry_status
jmp set_sign_zero_from_reg

// Add 16 bit memory to register
add_mem_reg_long:
clc
bcc _add_mem_reg_long
// Add with carry
add_carry_mem_reg_long:
jsr load_carry_status
_add_mem_reg_long:
jsr add_mem_reg_start_2
lda #0
adc 2(_r_0),x
sta 2(_r_0),x
lda #0
adc 3(_r_0),x
sta 3(_r_0),x
jsr set_carry_status
jmp set_sign_zero_from_reg

// Add 32 bit memory to register
add_mem_reg_double:
clc
bcc _add_mem_reg_long
// Add with carry
add_carry_mem_reg_long:
jsr load_carry_status
_add_mem_reg_long:
jsr add_mem_reg_start_2
iny
jsr _load_byte_temp
adc 2(_r_0),x
sta 2(_r_0),x
iny
jsr _load_byte_temp
adc 3(_r_0),x
sta 3(_r_0),x
jsr set_carry_status
jmp set_sign_zero_from_reg

// Subtract 32 bit constant from register
sub_const_reg:
sec
bcs _sub_const_reg
// Subtract with carry
sub_carry_const_reg:
jsr load_carry_status
_sub_const_reg:
ldy #1
jsr _load_byte_pc
sta 0(_r_temp)
lda 0(_r_0),x
sbc 0(_r_temp)
sta 0(_r_0),x
iny
jsr _load_byte_pc
sta 0(_r_temp)
lda 1(_r_0),x
sbc 0(_r_temp)
sta 1(_r_0),x
iny
jsr _load_byte_pc
sta 0(_r_temp)
lda 2(_r_0),x
sbc 0(_r_temp)
sta 2(_r_0),x
iny
jsr _load_byte_pc
sta 0(_r_temp)
lda 3(_r_0),x
sbc 0(_r_temp)
sta 3(_r_0),x
jsr set_carry_status
jsr set_sign_zero_from_reg
jmp inc_pc_4

// Compare a 32 constant and register
cmp_const_reg:
sec
ldy #1
jsr _load_byte_pc
sta 0(_r_temp)
lda 0(_r_0),x
sbc 0(_r_temp)
sta 0(_r_temp)
iny
jsr _load_byte_pc
sta 1(_r_temp)
lda 1(_r_0),x
sbc 1(_r_temp)
sta 1(_r_temp)
iny
jsr _load_byte_pc
sta 2(_r_temp)
lda 2(_r_0),x
sbc 2(_r_temp)
sta 2(_r_temp)
iny
jsr _load_byte_pc
sta 3(_r_temp)
lda 3(_r_0),x
sbc 3(_r_temp)
sta 3(_r_temp)
jsr set_carry_status
ldx #$40
jsr set_sign_zero_from_reg
jmp inc_pc_4

// Subtract register from register
sub_reg_reg:
sec
bcs _sub_reg_reg
// Subtract with carry
sub_carry_reg_reg:
jsr load_carry_status
_sub_reg_reg:
lda 0(_r_0),y
sbc 0(_r_0),x
sta 0(_r_0),y
lda 1(_r_0),y
sbc 1(_r_0),x
sta 1(_r_0),y
lda 2(_r_0),y
sbc 2(_r_0),x
sta 2(_r_0),y
lda 3(_r_0),y
sbc 3(_r_0),x
sta 3(_r_0),y
jsr set_carry_status
jmp set_sign_zero_from_reg

// Compare register and register
cmp_reg_reg:
sec
lda 0(_r_0),y
sbc 0(_r_0),x
sta 0(_r_temp)
lda 1(_r_0),y
sbc 1(_r_0),x
sta 1(_r_temp)
lda 2(_r_0),y
sbc 2(_r_0),x
sta 2(_r_temp)
lda 3(_r_0),y
sbc 3(_r_0),x
sta 3(_r_temp)
jsr set_carry_status
ldx #$40
jmp set_sign_zero_from_reg

// Helper for memory from register subtract
sub_mem_reg_start:
jsr get_mem_address
jsr _load_byte_temp
sta 0(_r_temp)
lda 0(_r_0),x
sbc 0(_r_temp)
rts

sub_mem_reg_start_2:
jsr sub_mem_reg_start
sta 0(_r_0),x
iny
jsr _load_byte_temp
sta 0(_r_temp)
lda 1(_r_0),x
sbc 0(_r_temp)
sta 1(_r_0),x
rts

// Subtract 8 bit memory from register
sub_mem_reg_short:
sec
bcs _sub_mem_reg_short
// Add with carry
sub_carry_mem_reg_short:
jsr load_carry_status
_sub_mem_reg_short:
jsr sub_mem_reg_start
sta 0(_r_0),x
lda 1(_r_0),x
sbc #0
sta 1(_r_0),x
lda 2(_r_0),x
sbc #0
sta 2(_r_0),x
lda 3(_r_0),x
sbc #0
sta 3(_r_0),x
jsr set_carry_status
jmp set_sign_zero_from_reg

// Compare 8 bit memory and register
cmp_mem_reg_short:
jsr sub_mem_reg_start
sta 0(_r_temp)
lda 1(_r_0),x
sbc #0
sta 1(_r_temp)
lda 2(_r_0),x
sbc #0
sta 2(_r_temp)
lda 3(_r_0),x
sbc #0
sta 3(_r_temp)
jsr set_carry_status
ldx #$40
jmp set_sign_zero_from_reg

// Subtract 16 bit memory from register
sub_mem_reg_long:
sec
bcs _sub_mem_reg_long
// Add with carry
sub_carry_mem_reg_long:
jsr load_carry_status
_sub_mem_reg_long:
jsr sub_mem_reg_start_2
lda 2(_r_0),x
sbc #0
sta 2(_r_0),x
lda 3(_r_0),x
sbc #0
sta 3(_r_0),x
jsr set_carry_status
jmp set_sign_zero_from_reg

// Compare 16 bit memory and register
cmp_mem_reg_long:
jsr sub_mem_reg_start
sta 0(_r_temp)
iny
jsr _load_byte_temp
sta 1(_r_temp)
lda 1(_r_0),x
sbc 1(_r_temp)
sta 1(_r_temp)
lda 2(_r_0),x
sbc #0
sta 2(_r_temp)
lda 3(_r_0),x
sbc #0
sta 3(_r_temp)
jsr set_carry_status
ldx #$40
jmp set_sign_zero_from_reg

// Subtract 32 bit memory from register
sub_mem_reg_double:
sec
bcs _sub_mem_reg_long
// Add with carry
sub_carry_mem_reg_long:
jsr load_carry_status
_sub_mem_reg_long:
jsr sub_mem_reg_start_2
iny
jsr _load_byte_temp
sta 0(_r_temp)
lda 2(_r_0),x
sbc 0(_r_temp)
sta 2(_r_0),x
iny
jsr _load_byte_temp
sta 0(_r_temp)
lda 3(_r_0),x
sbc 0(_r_temp)
sta 3(_r_0),x
jsr set_carry_status
jmp set_sign_zero_from_reg

// Compare 32 bit memory and register
cmp_mem_reg_double:
jsr sub_mem_reg_start
sta 0(_r_temp)
iny
jsr _load_byte_temp
sta 1(_r_temp)
lda 1(_r_0),x
sbc 1(_r_temp)
sta 1(_r_temp)
iny
jsr _load_byte_temp
sta 2(_r_temp)
lda 2(_r_0),x
sbc 2(_r_temp)
sta 2(_r_temp)
iny
jsr _load_byte_temp
sta 3(_r_temp)
lda 3(_r_0),x
sbc 3(_r_temp)
sta 3(_r_temp)
jsr set_carry_status
ldx #$40
jmp set_sign_zero_from_reg

// Multiply
_multiply_op1_l: .byte #0
_multiply_op1_h: .byte #0
_multiply_op2_l: .byte #0
_multiply_op2_h: .byte #0
_multiply_result_l: .byte #0
_multiply_result_h: .byte #0

_multiply:
lda #0
sta _multiply_result_h
sta _multiply_result_l
ldx #16
_multiply_1:
lsr _multiply_op2_l
ror _multiply_op2_h
bcc _multiply_2
clc
lda _multiply_op1_l
adc _multiply_result_l
sta _multiply_result_l
lda _multiply_op1_h
adc _multiply_result_h
sta _multiply_result_h
_multiply_2:
clc
asl _multiply_op1_l
rol _multiply_op1_h
dex
bne _multiply_1

// Increment register
inc_reg:
inc 0(_r_0),x
bne _inc_reg
inc 1(_r_0),x
bne _inc_reg
inc 2(_r_0),x
bne _inc_reg
inc 3(_r_0),x
_inc_reg:
jmp set_sign_zero_from_reg

// Increment 8bit memory
inc_mem_short:
jsr get_mem_address
clc
jsr _load_byte_temp
adc #1
jsr _save_byte_temp
sta 0(_r_temp)
lda #0
sta 1(_r_temp)
sta 2(_r_temp)
sta 3(_r_temp)
ldx #$40
jmp set_sign_zero_from_reg

// Increment 16bit memory
inc_mem_long:
jsr get_mem_address
clc
jsr _load_byte_temp
adc #1
jsr _save_byte_temp
sta 0(_r_temp)
iny
jsr _load_byte_temp
adc #0
jsr _save_byte_temp
sta 1(_r_temp)
lda #0
sta 2(_r_temp)
sta 3(_r_temp)
ldx #$40
jmp set_sign_zero_from_reg

// Increment 32bit memory
inc_mem_double:
jsr get_mem_address
clc
jsr _load_byte_temp
adc #1
jsr _save_byte_temp
sta 0(_r_temp)
iny
jsr _load_byte_temp
adc #0
jsr _save_byte_temp
sta 1(_r_temp)
iny
jsr _load_byte_temp
adc #0
jsr _save_byte_temp
sta 2(_r_temp)
iny
jsr _load_byte_temp
adc #0
jsr _save_byte_temp
sta 3(_r_temp)
ldx #$40
jmp set_sign_zero_from_reg

// Decrement register
dec_reg:
lda 0(_r_0),x
bne _dec_reg_1
lda 1(_r_0),x
bne _dec_reg_2
lda 2(_r_0),x
bne _dec_reg_3
dec 3(_r_0),x
_dec_reg_3:
dec 2(_r_0),x
_dec_reg_2:
dec 1(_r_0),x
_dec_reg_1:
dec 0(_r_0),x
jmp set_sign_zero_from_reg

dec_mem_1:
jsr get_mem_address
sec
jsr _load_byte_temp
sbc #0
jsr _save_byte_temp
sta 0(_r_temp)
rts

dec_mem_2:
jsr dec_mem_1
iny
jsr _load_byte_temp
sbc #0
jsr _save_byte_temp
sta 1(_r_temp)
rts

// Decrement 8bit memory
dec_mem_short:
jsr dec_mem_1
lda #0
sta 1(_r_temp)
sta 2(_r_temp)
sta 3(_r_temp)
ldx #$40
jmp set_sign_zero_from_reg

// Decrement 16bit memory
dec_mem_long:
jsr dec_mem_2
lda #0
sta 2(_r_temp)
sta 3(_r_temp)
ldx #$40
jmp set_sign_zero_from_reg

// Decrement 32bit memory
dec_mem_double:
jsr dec_mem_2
iny
jsr _load_byte_temp
sbc #0
jsr _save_byte_temp
sta 2(_r_temp)
iny
jsr _load_byte_temp
sbc #0
jsr _save_byte_temp
sta 3(_r_temp)
ldx #$40
jmp set_sign_zero_from_reg

// Logical and constant and register
and_const_reg:
ldy #1
jsr _load_byte_pc
and 0(_r_0),x
sta 0(_r_0),x
iny
jsr _load_byte_pc
and 1(_r_0),x
sta 1(_r_0),x
iny
jsr _load_byte_pc
and 2(_r_0),x
sta 2(_r_0),x
iny
jsr _load_byte_pc
and 3(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jsr clear_carry
jmp inc_pc_4

// Logical and register and register
and_reg_reg:
lda 0(_r_0),y
and 0(_r_0),x
sta 0(_r_0),y
lda 1(_r_0),y
and 1(_r_0),x
sta 1(_r_0),y
lda 2(_r_0),y
and 2(_r_0),x
sta 2(_r_0),y
lda 3(_r_0),y
and 3(_r_0),x
sta 3(_r_0),y
tya
tax
jsr set_sign_zero_from_reg
jmp clear_carry

// Helper for memory and register logical and
and_mem_reg_start:
jsr get_mem_address
jsr _load_byte_temp
and 0(_r_0),x
sta 0(_r_0),x
rts

and_mem_reg_start_2:
jsr and_mem_reg_start
iny
jsr _load_byte_temp
and 1(_r_0),x
sta 1(_r_0),x
rts

// 8 bit logical and memory anh register
and_mem_reg_short:
jsr and_mem_reg_start
lda #0
sta 1(_r_0),x
sta 2(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jmp clear_carry

// 16 bit logical and memory and register
and_mem_reg_long:
jsr and_mem_reg_start_2
lda #0
sta 2(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jmp clear_carry

// 32 bit logical and memory and register
and_mem_reg_double:
jsr and_mem_reg_start_2
iny
jsr _load_byte_temp
and 2(_r_0),x
sta 2(_r_0),x
iny
jsr _load_byte_temp
and 3(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jmp clear_carry

// Logical or constant and register
or_const_reg:
ldy #1
jsr _load_byte_pc
ora 0(_r_0),x
sta 0(_r_0),x
iny
jsr _load_byte_pc
ora 1(_r_0),x
sta 1(_r_0),x
iny
jsr _load_byte_pc
ora 2(_r_0),x
sta 2(_r_0),x
iny
jsr _load_byte_pc
ora 3(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jsr clear_carry
jmp inc_pc_4

// Logical or register and register
or_reg_reg:
lda 0(_r_0),y
ora 0(_r_0),x
sta 0(_r_0),y
lda 1(_r_0),y
ora 1(_r_0),x
sta 1(_r_0),y
lda 2(_r_0),y
ora 2(_r_0),x
sta 2(_r_0),y
lda 3(_r_0),y
ora 3(_r_0),x
sta 3(_r_0),y
tya
tax
jsr set_sign_zero_from_reg
jmp clear_carry

// Helper for memory and register logical or
or_mem_reg_start:
jsr get_mem_address
jsr _load_byte_temp
ora 0(_r_0),x
sta 0(_r_0),x
rts

or_mem_reg_start_2:
jsr or_mem_reg_start
iny
jsr _load_byte_temp
ora 1(_r_0),x
sta 1(_r_0),x
rts

// 8 bit logical or memory anh register
or_mem_reg_short:
jsr or_mem_reg_start
lda #0
sta 1(_r_0),x
sta 2(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jmp clear_carry

// 16 bit logical or memory and register
or_mem_reg_long:
jsr or_mem_reg_start_2
lda #0
sta 2(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jmp clear_carry

// 32 bit logical or memory and register
or_mem_reg_double:
jsr or_mem_reg_start_2
iny
jsr _load_byte_temp
ora 2(_r_0),x
sta 2(_r_0),x
iny
jsr _load_byte_temp
ora 3(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jmp clear_carry

// Logical xor constant and register
xor_const_reg:
ldy #1
jsr _load_byte_pc
eor 0(_r_0),x
sta 0(_r_0),x
iny
jsr _load_byte_pc
eor 1(_r_0),x
sta 1(_r_0),x
iny
jsr _load_byte_pc
eor 2(_r_0),x
sta 2(_r_0),x
iny
jsr _load_byte_pc
eor 3(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jsr clear_carry
jmp inc_pc_4

// Logical xor register and register
xor_reg_reg:
lda 0(_r_0),y
eor 0(_r_0),x
sta 0(_r_0),y
lda 1(_r_0),y
eor 1(_r_0),x
sta 1(_r_0),y
lda 2(_r_0),y
eor 2(_r_0),x
sta 2(_r_0),y
lda 3(_r_0),y
eor 3(_r_0),x
sta 3(_r_0),y
tya
tax
jsr set_sign_zero_from_reg
jmp clear_carry

// Helper for memory and register logical xor
xor_mem_reg_start:
jsr get_mem_address
jsr _load_byte_temp
eor 0(_r_0),x
sta 0(_r_0),x
rts

xor_mem_reg_start_2:
jsr or_mem_reg_start
iny
jsr _load_byte_temp
eor 1(_r_0),x
sta 1(_r_0),x
rts

// 8 bit logical xor memory anh register
xor_mem_reg_short:
jsr xor_mem_reg_start
lda #0
sta 1(_r_0),x
sta 2(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jmp clear_carry

// 16 bit logical xor memory and register
xor_mem_reg_long:
jsr xor_mem_reg_start_2
lda #0
sta 2(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jmp clear_carry

// 32 bit logical xor memory and register
xor_mem_reg_double:
jsr or_mem_reg_start_2
iny
jsr _load_byte_temp
eor 2(_r_0),x
sta 2(_r_0),x
iny
jsr _load_byte_temp
eor 3(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jmp clear_carry

// Logical not register
not_reg:
lda 0(_r_0),x
eor #$ff
sta 0(_r_0),x
lda 1(_r_0),x
eor #$ff
sta 1(_r_0),x
lda 2(_r_0),x
eor #$ff
sta 2(_r_0),x
lda 3(_r_0),x
eor #$ff
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jmp clear_carry

// Logical not 8bit memory
not_mem_short:
jsr get_mem_address
jsr _load_byte_temp
eor #$ff
jsr _save_byte_temp
sta 0(_r_temp)
sta 1(_r_temp)
sta 2(_r_temp)
sta 3(_r_temp)
ldx #$40
jsr set_sign_zero_from_reg
jmp clear_carry

// Logical not 16bit memory
not_mem_long:
jsr not_mem_short
iny
jsr _load_byte_temp
eor #$ff
jsr _save_byte_temp
sta 1(_r_temp)
sta 2(_r_temp)
sta 3(_r_temp)
ldx #$40
jsr set_sign_zero_from_reg
jmp clear_carry

// Logical not 32bit memory
not_mem_double:
jsr not_mem_long
iny
jsr _load_byte_temp
eor #$ff
jsr _save_byte_temp
sta 2(_r_temp)
iny
jsr _load_byte_temp
eor #$ff
jsr _save_byte_temp
sta 3(_r_temp)
ldx #$40
jsr set_sign_zero_from_reg
jmp clear_carry

// 2's compliment negate register
neg_reg:
sec
lda #0
sbc 0(_r_0),x
sta 0(_r_0),x
lda #0
sbc 1(_r_0),x
sta 1(_r_0),x
lda #0
sbc 2(_r_0),x
sta 2(_r_0),x
lda #0
sbc 3(_r_0),x
sta 3(_r_0),x
jsr set_sign_zero_from_reg
jmp clear_carry

// 2's compliment negate 8bit memory
neg_mem_short:
jsr get_mem_address
jsr _load_byte_temp
sta 0(_r_temp)
sec
lda #0
sbc 0(_r_temp)
jsr _save_byte_temp
sta 0(_r_temp)
asl 0(_r_temp)
bcs _neg_mem_short_1
lda #0
bcc _neg_mem_short_2
_neg_mem_short_1:
lda #$FF
_neg_mem_short_2:
ror 0(_r_temp)
sta 1(_r_temp)
sta 2(_r_temp)
sta 3(_r_temp)
ldx #$40
jsr set_sign_zero_from_reg
jmp clear_carry

// 2's compliment negate 16bit memory
neg_mem_long:
jsr get_mem_address
jsr _load_byte_temp
sta 0(_r_temp)
sec
lda #0
sbc 0(_r_temp)
jsr _save_byte_temp
sta 0(_r_temp)
iny
jsr _load_byte_temp
sta 1(_r_temp)
sec
lda #0
sbc 1(_r_temp)
jsr _save_byte_temp
sta 1(_r_temp)
asl 1(_r_temp)
bcs _neg_mem_short_1
lda #0
bcc _neg_mem_short_2
_neg_mem_short_1:
lda #$FF
_neg_mem_short_2:
ror 1(_r_temp)
sta 2(_r_temp)
sta 3(_r_temp)
ldx #$40
jsr set_sign_zero_from_reg
jmp clear_carry

// 2's compliment negate 32bit memory
neg_mem_double:
jsr get_mem_address
jsr _load_byte_temp
sta 0(_r_temp)
sec
lda #0
sbc 0(_r_temp)
jsr _save_byte_temp
sta 0(_r_temp)
iny
jsr _load_byte_temp
sta 1(_r_temp)
sec
lda #0
sbc 1(_r_temp)
jsr _save_byte_temp
sta 1(_r_temp)
iny
jsr _load_byte_temp
sta 2(_r_temp)
sec
lda #0
sbc 2(_r_temp)
jsr _save_byte_temp
sta 2(_r_temp)
iny
jsr _load_byte_temp
sta 3(_r_temp)
sec
lda #0
sbc 3(_r_temp)
jsr _save_byte_temp
sta 3(_r_temp)
ldx #$40
jsr set_sign_zero_from_reg
jmp clear_carry

// Push program counter and jump to memory location
call_subroutine:
jsr get_mem_address
jsr dec_mem_address
ldx #$3C
jsr push_reg
lda $8a
sta 0(_r_pc)
lda $8b
sta 1(_r_pc)
lda $8c
sta 2(_r_pc)
lda $8d
sta 3(_r_pc)
rts

// Jump to memory location
jump:
jsr get_mem_address
jsr dec_mem_address
lda $8a
sta 0(_r_pc)
lda $8b
sta 1(_r_pc)
lda $8c
sta 2(_r_pc)
lda $8d
sta 3(_r_pc)
rts

_jump_zero_start:
jsr get_mem_address
lda 0(_r_status)
and #$02
rts

// Jump when result of comparison is zero
jump_zero:
jsr _jump_zero_start
beq _jump_test_fail
jmp _jump_test_end

// Jump when result of comparison is not zero
jump_not_zero:
jsr _jump_zero_start
bne _jump_test_fail
jmp _jump_test_end

_jump_above_start_1:
jsr get_mem_address
_jump_above_start_2:
lda 0(_r_status)
and #$01
rts

// Jump when a >= b unsigned
jump_above_equal:
jsr _jump_zero_start
bne _jump_test_end
jsr _jump_above_start_2
bne _jump_test_fail
jmp _jump_test_end

// Jump when a > b unsigned
jump_above:
jsr _jump_above_start_1
bne _jump_test_fail
jmp _jump_test_end

// Jump when a < b unsigned
jump_below:
jsr _jump_zero_start
bne _jump_test_fail
jsr _jump_above_start_2
bne _jump_test_end
jmp _jump_test_fail

// Jump when a <= b unsigned
jump_below_equal:
jsr _jump_above_start_1
bne _jump_test_end
jmp _jump_test_fail

_jump_lesser_start:
jsr get_mem_address
lda 0(_r_status)
and #$04
lsr a
lsr a
sta 0(_r_temp)
lda 0(_r_status)
and #$08
lsr a
lsr a
lsr a
eor 0(_r_temp)
lsr a
rts

_jump_test_end:
jsr dec_mem_address
lda $8a
sta 0(_r_pc)
lda $8b
sta 1(_r_pc)
lda $8c
sta 2(_r_pc)
lda $8d
sta 3(_r_pc)
_jump_test_fail:
rts

// Jump when a < b signed
jump_lesser:
jsr _jump_above_start_2
bcs _jump_test_fail
jsr _jump_lesser_start
bcs _jump_test_fail
bcc _jump_test_end

// Jump when a <= b signed
jump_lesser_equal:
jsr _jump_lesser_start
bcs _jump_test_fail
bcc _jump_test_end

// Jump when a >= b signed
jump_greater_equal:
jsr _jump_lesser_start
bcs _jump_test_end
jsr _jump_above_start_2
bcs _jump_test_end
bcc _jump_test_fail

// Jump when a > b signed
jump_greater:
jsr _jump_lesser_start
bcc _jump_test_fail
bcs _jump_test_end

// JSR to native 6502 code with accumulator set from a register and then the accumulator after RTS loaded into the register
call_6502:
jsr get_mem_address
stx 0(_r_temp)
lda 0(_r_0),x
jsr _call_6502
ldx 0(_r_temp)
sta 0(_r_0),x
lda #0
sta 1(_r_0),x
sta 2(_r_0),x
sta 3(_r_0),x
rts
_call_6502:
jmp ($8a)

return:
ldx #$3C
jmp pop_reg

exit_vm:
pla
pla
rts

halt_and_catch_fire:
.byte #2