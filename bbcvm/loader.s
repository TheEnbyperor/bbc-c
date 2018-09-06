.export _start

_start:
jmp _start_loader

file_not_found: .byte "Unable to open file",#$0D,#0
file_loaded: .byte "File loaded into extended memory",#$0D,#0
file_pointer: .byte #0, #0, #0, #0

print_string:
ldy #0
print_string_start:
lda ($70),y
beq print_string_end
jsr $FFE3
iny
jmp print_string_start
print_string_end:
rts

_start_loader:

// Get command line parameters
ldx #$70
ldy #0
lda #1
jsr $FFDA

// Set termination byte for OSFIND
ldy #0
set_return_byte:
lda ($70),y
cmp #$0D
beq set_return_byte_end
cmp #$20
beq set_return_byte_space
iny
cpy #$ff
beq set_return_byte_end
bne set_return_byte
set_return_byte_space:
lda #$0D
sta ($70),y
set_return_byte_end:

// Attempt to open file
ldx $70
ldy $71
lda #$40
jsr $FFCE

// Print error message and exit if fail
bne open_file_success
lda #0(file_not_found)
sta $70
lda #1(file_not_found)
sta $71
jsr print_string
rts

// Save file handle on success
open_file_success:
tay

// Setup indirect for writing to memory
lda #$FD
sta $71
ldx #0

// Setup memory banks
stx $FC00
stx $FC01
stx $FC02
stx $70

transfer_loop:
// Read byte from file into extended memory
jsr $FFD7
bcs transfer_end
sta ($70,x)

// Increment file pointer and update memory banks if nescacary
inc 0(file_pointer)
lda 0(file_pointer)
sta $70
bne inc_fp
inc 1(file_pointer)
lda 1(file_pointer)
sta $FC00
bne inc_fp
inc 2(file_pointer)
lda 3(file_pointer)
sta $FC01
bne inc_fp
inc 3(file_pointer)
lda 3(file_pointer)
sta $FC02
inc_fp:

jmp transfer_loop

transfer_end:
// Close file
lda #0
jsr $FFCE

// Print success message
lda #0(file_loaded)
sta $70
lda #1(file_loaded)
sta $71
jsr print_string

rts