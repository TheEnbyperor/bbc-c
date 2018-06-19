# 16-bit virtual machine for the 6502 - Instruction set

## Registers

There are 15 registers available R0-R14. Each register is 16-bits long. R15 does exist but it is used by many instructions as a scratch space, as such its use is not recommended. Instructions that don't clobber R15 are marked as such.

A few registers have special purposes.

| Register | Purpose                |
| -------- | ---------------------- |
| R14      | Program counter        |
| R13      | Stack pointer          |
| R12      | Status register in LSB |

The status register is as such, where X means not used.

|  7   |  6   |  5   |  4   |  3   |  2   |  1   |   0   |
| :--: | :--: | :--: | :--: | :--: | :--: | :--: | :---: |
|  X   |  X   |  X   |  X   |  X   | Sign | Zero | Carry |



## Entering the VM

The VM in entered by a jsr to the start address (label _start). All data following is interpreted by the VM.

## General layout of each instruction

The first byte is always the value of the instruction. 

If the first bit of the instruction is 0 then; the second byte contains two register locations, the second one is always used for instructions with 1 register operand, while the first is used as the second register where required. It may also be used to specify memory addressing modes in the future.

|     Bits 0-7      |                Bits 8-11                 |      Bits 12-15       |
| :---------------: | :--------------------------------------: | :-------------------: |
| Instruction value | Second register number/memory addressing mode (may be set to anything if not used in instruction) | First register number |

When a memory value or constant is required in is stored in little-endian after the first two bytes of the instruction.

If the first bit of the instruction is 1 then the data after is purely instruction dependent and may be nothing (i.e. next instruction)

## Addressing modes

On instructions starting with a 0 the second register operand (first in memory) may be used to specify the addressing mode of the memory operand. It may be set as such:

| Register operand (binary) |  Addressing mode  |
| :-----------------------: | :---------------: |
|           0000            | Absolute address  |
|           0001            |   Relative add    |
|           0010            | Relative subtract |
|           0011            | Register indirect |

When relative addressing is used it is relative to the address of start of the instruction.

Register indirect allows using the value stored in a register plus a 12-bit signed offset. The data is stored in the memory location as such:

| Bits 0-3        | Bits 4-7         | Bits 8-15        |
| --------------- | ---------------- | ---------------- |
| Register number | Offset value LSB | Offset value MSB |



## List of instructions

The instructions available are similar to x86 16-bit mode, but with a few simplifications.

### mov \<const\>, \<reg\>

Moves the 16 bit constant into the register

*Does not clobber R15*

#### Flags

None affected

| Bit 0-7 | Bits 8-11 |   Bits 12-15    | Bits 16-31 |
| :-----: | :-------: | :-------------: | :--------: |
|  0x00   | Anything  | Register number |  Constant  |

### movs \<mem\>, \<reg\>

Moves the 8 bit value at the memory location into the LSB of the register and 0 into the MSB

#### Flags

None affected

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x01   | Addressing mode | Register number | Memory location |

### mov \<mem\>, \<reg\>

Moves the 16 bit value at the memory location into the register

#### Flags

None affected

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x01   | Addressing mode | Register number | Memory location |

### movs \<reg\>, \<mem\>

Moves the LSB of the register to the memory location

#### Flags

None affected

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x03   | Addressing mode | Register number | Memory location |

### mov \<reg\>, \<mem\>

Moves the register to the 16-bit memory location

#### Flags

None affected

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x04   | Addressing mode | Register number | Memory location |

### mov \<reg\>, \<reg\>

Moves the first register to the second register

*Does not clobber R15*

#### Flags

None affected

| Bit 0-7 |       Bits 8-11        |      Bits 12-15       |
| :-----: | :--------------------: | :-------------------: |
|  0x05   | Second register number | First register number |

### push \<reg\>

Pushes the register onto the stack

*Does not clobber R15*

#### Flags

None affected

| Bit 0-7 | Bits 8-11 |   Bits 12-15    |
| :-----: | :-------: | :-------------: |
|  0x06   | Anything  | Register number |

### pop \<reg\>

Pops the 16-value off the top of the stack and puts it in the register

*Does not clobber R15*

#### Flags

None affected

| Bit 0-7 | Bits 8-11 |   Bits 12-15    |
| :-----: | :-------: | :-------------: |
|  0x07   | Anything  | Register number |

### la \<mem\>, \<reg\>

Loads the address which data would be read from into the register. Not currently any more useful than moving a constant into a register, but will be once indirection is added.

#### Flags

None affected

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-32    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x08   | Addressing mode | Register number | Memory location |

### sec

Sets the carry flag

*Does not clobber R15*

#### Flags

Carry

| Bit 0-7 |
| :-----: |
|  0x80   |

### clc

Clears the carry flag

*Does not clobber R15*

#### Flags

Carry

| Bit 0-7 |
| :-----: |
|  0x81   |

### add \<const>, \<reg>

Adds the constant value to the register and stores back in the register. Does not use the carry flag.

*Does not clobber R15*

#### Flags

Carry, sign, zero

| Bit 0-7 | Bits 8-11 |   Bits 12-15    | Bits 16-32 |
| :-----: | :-------: | :-------------: | :--------: |
|  0x09   | Anything  | Register number |  Constant  |

###add \<reg>, \<reg>

Adds the value in the first register to the second register and stores back in the first register. Does not use the carry flag.

*Does not clobber R15*

#### Flags

Carry, sign, zero

| Bit 0-7 |       Bits 8-11        |      Bits 12-15       |
| :-----: | :--------------------: | :-------------------: |
|  0x0B   | Second register number | First register number |

### adds \<mem\>, \<reg\>

Adds the 8 bit value at the memory location into the the register and stores in the register. Does not use the carry flag.

#### Flags

Carry, sign, zero

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x0D   | Addressing mode | Register number | Memory location |

### add \<mem\>, \<reg\>

Adds the 16 bit value at the memory location to the register and stores in the register. Does not use the carry flag.

#### Flags

Carry, sign, zero

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x0F   | Addressing mode | Register number | Memory location |

### adc \<const>, \<reg>

Adds the constant value plus the carry to the register and stores back in the register.

*Does not clobber R15*

#### Flags

Carry, sign, zero

| Bit 0-7 | Bits 8-11 |   Bits 12-15    | Bits 16-32 |
| :-----: | :-------: | :-------------: | :--------: |
|  0x0A   | Anything  | Register number |  Constant  |

### adc \<reg>, \<reg>

Adds the value in the first register plus the carry to the second register and stores back in the first register.

*Does not clobber R15*

#### Flags

Carry, sign, zero

| Bit 0-7 |       Bits 8-11        |      Bits 12-15       |
| :-----: | :--------------------: | :-------------------: |
|  0x0C   | Second register number | First register number |

### adcs \<mem\>, \<reg\>

Adds the 8 bit value at the memory location plus the carry into the the register and stores in the register.

#### Flags

Carry, sign, zero

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x0E   | Addressing mode | Register number | Memory location |

### adc \<mem\>, \<reg\>

Adds the 16 bit value at the memory location plus the carry to the register and stores in the register.  

#### Flags

Carry, sign, zero

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x10   | Addressing mode | Register number | Memory location |

###  sub \<const>, \<reg>

Subtracts the constant value from the register and stores back in the register. Does not use the carry flag.

*Does not clobber R15*

#### Flags

Carry, sign, zero

| Bit 0-7 | Bits 8-11 |   Bits 12-15    | Bits 16-32 |
| :-----: | :-------: | :-------------: | :--------: |
|  0x11   | Anything  | Register number |  Constant  |

### sub \<reg>, \<reg>

Subtracts the value in the first register from the second register and stores back in the first register. Does not use the carry flag.

*Does not clobber R15*

#### Flags

Carry, sign, zero

| Bit 0-7 |       Bits 8-11        |      Bits 12-15       |
| :-----: | :--------------------: | :-------------------: |
|  0x13   | Second register number | First register number |

### subs \<mem\>, \<reg\>

Subtracts the 8 bit value at the memory location from the the register and stores in the register. Does not use the carry flag.

#### Flags

Carry, sign, zero

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x15   | Addressing mode | Register number | Memory location |

### sub \<mem\>, \<reg\>

Subtracts the 16 bit value at the memory location from the register and stores in the register. Does not use the carry flag.

#### Flags

Carry, sign, zero

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x17   | Addressing mode | Register number | Memory location |

### sbc \<const>, \<reg>

Subtracts the constant value and the carry from the register and stores back in the register.

*Does not clobber R15*

#### Flags

Carry, sign, zero

| Bit 0-7 | Bits 8-11 |   Bits 12-15    | Bits 16-32 |
| :-----: | :-------: | :-------------: | :--------: |
|  0x12   | Anything  | Register number |  Constant  |

### sbc \<reg>, \<reg\>

Subtracts the value in the first register and the carry from the second register and stores back in the first register.

*Does not clobber R15*

#### Flags

Carry, sign, zero

| Bit 0-7 |       Bits 8-11        |      Bits 12-15       |
| :-----: | :--------------------: | :-------------------: |
|  0x14   | Second register number | First register number |

### sbcs \<mem\>, \<reg\>

Subtracts the 8 bit value at the memory location and the carry from the the register and stores in the register.

#### Flags

Carry, sign, zero

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x16   | Addressing mode | Register number | Memory location |

### sbc \<mem\>, \<reg\>

Subtracts the 16 bit value at the memory location and the carry from the register and stores in the register.

#### Flags

Carry, sign, zero

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x18   | Addressing mode | Register number | Memory location |

### inc \<reg\>

Increments the register

*Does not clobber R15*

#### Flags

Sign, zero

| Bit 0-7 | Bits 8-11 |   Bits 12-15    |
| :-----: | :-------: | :-------------: |
|  0x19   | Anything  | Register number |

### dec \<reg\>

Decrements the register

*Does not clobber R15*

#### Flags

Sign, zero

| Bit 0-7 | Bits 8-11 |   Bits 12-15    |
| :-----: | :-------: | :-------------: |
|  0x1A   | Anything  | Register number |

### and \<const>, \<reg>

Logical ands the constant with the register and stores in the register

*Does not clobber R15*

#### Flags

Sign, zero, clears carry

| Bit 0-7 | Bits 8-11 |   Bits 12-15    | Bits 16-32 |
| :-----: | :-------: | :-------------: | :--------: |
|  0x1B   | Anything  | Register number |  Constant  |

### and \<reg>, \<reg>

Logical ands the first register with the second register and stores in the first register

*Does not clobber R15*

#### Flags

Sign, zero, clears carry

| Bit 0-7 |       Bits 8-11        |      Bits 12-15       |
| :-----: | :--------------------: | :-------------------: |
|  0x1C   | Second register number | First register number |

### ands \<mem\>, \<reg\>

Logical ands the 8 bit value at the memory location (LSB) and 0 (MSB) with the register and stores in the register

#### Flags

Sign, zero, clears carry

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x1D   | Addressing mode | Register number | Memory location |

### and \<mem\>, \<reg\>

Logical ands the 16 bit value at the memory location with the register and stores in the register

#### Flags

Sign, zero, clears carry

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x1E   | Addressing mode | Register number | Memory location |

### or \<const>, \<reg\>

Logical ors the constant with the register and stores in the register

*Does not clobber R15*

#### Flags

Sign, zero, clears carry

| Bit 0-7 | Bits 8-11 |   Bits 12-15    | Bits 16-32 |
| :-----: | :-------: | :-------------: | :--------: |
|  0x1F   | Anything  | Register number |  Constant  |

### or \<reg>, \<reg>

Logical ors the first register with the second register and stores in the first register

*Does not clobber R15*

#### Flags

Sign, zero, clears carry

| Bit 0-7 |       Bits 8-11        |      Bits 12-15       |
| :-----: | :--------------------: | :-------------------: |
|  0x20   | Second register number | First register number |

### ors \<mem\>, \<reg\>

Logical ors the 8 bit value at the memory location (LSB) and 0 (MSB) with the register and stores in the register

#### Flags

Sign, zero, clears carry

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x21   | Addressing mode | Register number | Memory location |

### or \<mem\>, \<reg\>

Logical ors the 16 bit value at the memory location with the register and stores in the register

#### Flags

Sign, zero, clears carry

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x22   | Addressing mode | Register number | Memory location |

### xor \<const>, \<reg>

Logical xors the constant with the register and stores in the register

*Does not clobber R15*

#### Flags

Sign, zero, clears carry

| Bit 0-7 | Bits 8-11 |   Bits 12-15    | Bits 16-32 |
| :-----: | :-------: | :-------------: | :--------: |
|  0x23   | Anything  | Register number |  Constant  |

### xor \<reg>, \<reg>

Logical xors the first register with the second register and stores in the first register

*Does not clobber R15*

#### Flags

Sign, zero, clears carry

| Bit 0-7 |       Bits 8-11        |      Bits 12-15       |
| :-----: | :--------------------: | :-------------------: |
|  0x24   | Second register number | First register number |

### xors \<mem\>, \<reg\>

Logical xors the 8 bit value at the memory location (LSB) and 0 (MSB) with the register and stores in the register

#### Flags

Sign, zero, clears carry

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x25   | Addressing mode | Register number | Memory location |

### xor \<mem\>, \<reg\>

Logical ands the 16 bit value at the memory location with the register and stores in the register

#### Flags

Sign, zero, clears carry

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x26   | Addressing mode | Register number | Memory location |

### not \<reg>

Logical nots the register

*Does not clobber R15*

#### Flags

None

| Bit 0-7 | Bits 8-11 |   Bits 12-15    |
| :-----: | :-------: | :-------------: |
|  0x27   | Anything  | Register number |

### neg \<reg\>

Two's compliment negate of the register

*Does not clobber R15*

#### Flags

Sign, zero

| Bit 0-7 | Bits 8-11 |   Bits 12-15    |
| :-----: | :-------: | :-------------: |
|  0x28   | Anything  | Register number |

### cmp \<const>, \<reg\>

Subtracts the constant value from the register but does not store. Does not use the carry flag.

#### Flags

Carry, sign, zero

| Bit 0-7 | Bits 8-11 |   Bits 12-15    | Bits 16-32 |
| :-----: | :-------: | :-------------: | :--------: |
|  0x29   | Anything  | Register number |  Constant  |

### cmp \<reg>, \<reg>

Subtracts the value in the first register from the second register but does not store. Does not use the carry flag.

#### Flags

Carry, sign, zero

| Bit 0-7 |       Bits 8-11        |      Bits 12-15       |
| :-----: | :--------------------: | :-------------------: |
|  0x2A   | Second register number | First register number |

### cmp \<mem\>, \<reg\>

Subtracts the 8 bit value at the memory location from the the register but does not store. Does not use the carry flag.

#### Flags

Carry, sign, zero

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x2B   | Addressing mode | Register number | Memory location |

### cmp \<mem\>, \<reg\>

Subtracts the 16 bit value at the memory location from the register but does not store. Does not use the carry flag.

#### Flags

Carry, sign, zero

| Bit 0-7 |    Bits 8-11    |   Bits 12-15    |   Bits 16-31    |
| :-----: | :-------------: | :-------------: | :-------------: |
|  0x2C   | Addressing mode | Register number | Memory location |

### call \<mem\>

Pushes the current program counter onto the stack and jumps to the memory location. Note this will not return to this instruction since the PC is incremented **before** a fetch.

#### Flags

None

| Bit 0-7 |    Bits 8-11    | Bits 12-15 |   Bits 16-31    |
| :-----: | :-------------: | :--------: | :-------------: |
|  0x2D   | Addressing mode |  Anything  | Memory location |

### calln \<mem\>

Performs a jsr to native 6502 code. The code at the location will return to the VM on rts.

#### Flags

None

| Bit 0-7 |    Bits 8-11    | Bits 12-15 |   Bits 16-31    |
| :-----: | :-------------: | :--------: | :-------------: |
|  0x2E   | Addressing mode |  Anything  | Memory location |

### ret

Pops the program counter off the stack and continues at that address + 1.

#### Flags

None

| Bit 0-7 |
| :-----: |
|  0x83   |