import wx
import tty
import termios
import gui
import sys
import threading
import time
import struct
sys.path.append("..")
import bbcvmld


class Emulator(gui.EmulatorFrame):
    START_ADDR = 0x0
    CARRY      = 0b0001
    ZERO       = 0b0010
    SIGN       = 0b0100
    OVERFLOW   = 0b1000

    STATE_STOP = 0
    STATE_STEP = 1
    STATE_STEP_OVER = 2
    STATE_RUN = 3

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.exec = None
        self.regs = [bytearray([0]*4)] * 16
        self.mem = bytearray([0]) * ((2**24)-1)
        self.cur_mem_page = 0
        self.cur_breakpoints = []
        self.cur_state = self.STATE_STOP
        self.thread = threading.Thread(target=self.run_thread, daemon=True)
        self.thread.start()

        self.insts = {
            0x00: (self.parse_mov_const_reg, self.run_mov_const_reg),
            0x01: (self.parse_mov_mem_reg_short, self.run_mov_mem_reg_short),
            0x02: (self.parse_mov_mem_reg_long, self.run_mov_mem_reg_long),
            0x03: (self.parse_mov_mem_reg_double, self.run_mov_mem_reg_double),
            0x04: (self.parse_mov_reg_mem_short, self.run_mov_reg_mem_short),
            0x05: (self.parse_mov_reg_mem_long, self.run_mov_reg_mem_long),
            0x06: (self.parse_mov_reg_mem_double, self.run_mov_reg_mem_double),
            0x07: (self.parse_mov_reg_reg, self.run_mov_reg_reg),
            0x08: (self.parse_push_reg, self.run_push_reg),
            0x09: (self.parse_push_mem, self.run_push_mem),
            0x0a: (self.parse_pop_reg, self.run_pop_reg),
            0x0b: (self.parse_pop_mem, self.run_pop_mem),
            0x0c: (self.parse_lea, self.run_lea),
            0x0d: (self.parse_add_const_reg, self.run_add_const_reg),
            0x0e: (self.parse_adc_const_reg, self.run_adc_const_reg),
            0x0f: (self.parse_add_reg_reg, self.run_add_reg_reg),
            0x10: (self.parse_adc_reg_reg, self.run_adc_reg_reg),
            0x11: (self.parse_add_mem_reg_short, self.run_add_mem_reg_short),
            0x12: (self.parse_adc_mem_reg_short, self.run_adc_mem_reg_short),
            0x13: (self.parse_add_mem_reg_long, self.run_add_mem_reg_long),
            0x14: (self.parse_adc_mem_reg_long, self.run_adc_mem_reg_long),
            0x15: (self.parse_add_mem_reg_double, self.run_add_mem_reg_double),
            0x16: (self.parse_adc_mem_reg_double, self.run_adc_mem_reg_double),
            0x17: (self.parse_sub_const_reg, self.run_sub_const_reg),
            0x18: (self.parse_sbc_const_reg, self.run_sbc_const_reg),
            0x19: (self.parse_sub_reg_reg, self.run_sub_reg_reg),
            0x1a: (self.parse_sbc_reg_reg, self.run_sbc_reg_reg),
            0x1b: (self.parse_sub_mem_reg_short, self.run_sub_mem_reg_short),
            0x1c: (self.parse_sbc_mem_reg_short, self.run_sbc_mem_reg_short),
            0x1d: (self.parse_sub_mem_reg_long, self.run_sub_mem_reg_long),
            0x1e: (self.parse_sbc_mem_reg_long, self.run_sbc_mem_reg_long),
            0x1f: (self.parse_sub_mem_reg_double, self.run_sub_mem_reg_double),
            0x20: (self.parse_sbc_mem_reg_double, self.run_sbc_mem_reg_double),
            0x21: (self.parse_cmp_const_reg, self.run_cmp_const_reg),
            0x22: (self.parse_cmp_reg_reg, self.run_cmp_reg_reg),
            0x23: (self.parse_cmp_mem_reg_short, self.run_cmp_mem_reg_short),
            0x24: (self.parse_cmp_mem_reg_long, self.run_cmp_mem_reg_long),
            0x25: (self.parse_cmp_mem_reg_double, self.run_cmp_mem_reg_double),
            0x26: (self.parse_mul_const_reg, self.run_mul_const_reg),
            0x27: (self.parse_mul_reg_reg, self.run_mul_reg_reg),
            0x28: (self.parse_mul_mem_reg_short, self.run_mul_mem_reg_short),
            0x29: (self.parse_mul_mem_reg_long, self.run_mul_mem_reg_long),
            0x2a: (self.parse_mul_mem_reg_double, self.run_mul_mem_reg_double),
            0x2b: (self.parse_div_const_reg, self.run_div_const_reg),
            0x2c: (self.parse_div_reg_reg, self.run_div_reg_reg),
            0x2d: (self.parse_div_mem_reg_short, self.run_div_mem_reg_short),
            0x2e: (self.parse_div_mem_reg_long, self.run_div_mem_reg_long),
            0x2f: (self.parse_div_mem_reg_double, self.run_div_mem_reg_double),
            0x30: (self.parse_mod_const_reg, self.run_mod_const_reg),
            0x31: (self.parse_mod_reg_reg, self.run_mod_reg_reg),
            0x32: (self.parse_mod_mem_reg_short, self.run_mod_mem_reg_short),
            0x33: (self.parse_mod_mem_reg_long, self.run_mod_mem_reg_long),
            0x34: (self.parse_mod_mem_reg_double, self.run_mod_mem_reg_double),
            0x35: (self.parse_inc_reg, self.run_inc_reg),
            0x36: (self.parse_inc_mem_short, self.run_inc_mem_short),
            0x37: (self.parse_inc_mem_long, self.run_inc_mem_long),
            0x38: (self.parse_inc_mem_double, self.run_inc_mem_double),
            0x39: (self.parse_dec_reg, self.run_dec_reg),
            0x3a: (self.parse_dec_mem_short, self.run_dec_mem_short),
            0x3b: (self.parse_dec_mem_long, self.run_dec_mem_long),
            0x3c: (self.parse_dec_mem_double, self.run_dec_mem_double),
            # 0x3d: (self.parse_not_reg, self.run_not_reg),
            # 0x3e: (self.parse_not_mem_short, self.run_not_mem_short),
            # 0x3f: (self.parse_not_mem_long, self.run_not_mem_long),
            # 0x40: (self.parse_not_mem_double, self.run_not_mem_double),
            0x41: (self.parse_neg_reg, self.run_neg_reg),
            0x42: (self.parse_neg_mem_short, self.run_neg_mem_short),
            0x43: (self.parse_neg_mem_long, self.run_neg_mem_long),
            0x44: (self.parse_neg_mem_double, self.run_neg_mem_double),
            0x45: (self.parse_call, self.run_call),
            0x46: (self.parse_call_native, self.run_call_native),
            0x47: (self.parse_jump, self.run_jump),
            0x48: (self.parse_jump_zero, self.run_jump_zero),
            0x49: (self.parse_jump_not_zero, self.run_jump_not_zero),
            0x4a: (self.parse_jump_above, self.run_jump_above),
            0x4b: (self.parse_jump_above_equal, self.run_jump_above_equal),
            0x4c: (self.parse_jump_below, self.run_jump_below),
            0x4d: (self.parse_jump_below_equal, self.run_jump_below_equal),
            0x4e: (self.parse_jump_lesser, self.run_jump_lesser),
            0x4f: (self.parse_jump_lesser_equal, self.run_jump_lesser_equal),
            0x50: (self.parse_jump_greater, self.run_jump_greater),
            0x51: (self.parse_jump_greater_equal, self.run_jump_greater_equal),
            0x52: (self.parse_set_zero, self.run_set_zero),
            0x53: (self.parse_set_not_zero, self.run_set_not_zero),
            0x54: (self.parse_set_above, self.run_set_above),
            0x55: (self.parse_set_above_equal, self.run_set_above_equal),
            0x56: (self.parse_set_below, self.run_set_below),
            0x57: (self.parse_set_below_equal, self.run_set_below_equal),
            0x58: (self.parse_set_lesser, self.run_set_lesser),
            0x59: (self.parse_set_lesser_equal, self.run_set_lesser_equal),
            0x5a: (self.parse_set_greater, self.run_set_greater),
            0x5b: (self.parse_set_greater_equal, self.run_set_greater_equal),
            # 0x80: (self.parse_clear_carry, self.run_clear_carry),
            # 0x81: (self.parse_set_carry, self.run_set_carry),
            0x82: (self.parse_return, self.run_return),
            0x83: (self.parse_exit, self.run_exit),
        }

    def open_file(self, _):
        open_file_dialog = wx.FileDialog(self, "Open file", "", "",
                                         "Object Files (*.o)|*.o|All files|*",
                                         wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)

        open_file_dialog.ShowModal()
        file_path = open_file_dialog.GetPath()
        open_file_dialog.Destroy()

        with open(file_path, "rb") as f:
            code = bytearray(f.read())

        self.cur_state = self.STATE_STOP

        parser = bbcvmld.parser.Parser(code)
        self.exec = parser.parse()

        self.regs = [bytearray([0]*4)] * 16
        self.mem = bytearray([0]) * ((2**24)-1)
        self.cur_breakpoints = []
        self.mem = self.mem[:self.START_ADDR] + self.exec.code + self.mem[self.START_ADDR+len(self.exec.code):]
        self.set_reg(14, self.START_ADDR)

        self.update()

    def run_thread(self):
        prev_state = self.cur_state
        while True:
            if self.cur_state == self.STATE_STEP:
                prev_state = self.cur_state
                self.step()
                self.cur_state = self.STATE_STOP
            elif self.cur_state == self.STATE_STEP_OVER:
                prev_state = self.cur_state
                if self.is_subroutine():
                    next_addr = self.addr_after_subroutine()
                    while self.get_pc() != next_addr and self.cur_state == self.STATE_STEP_OVER:
                        self.step()
                else:
                    self.step()
                self.cur_state = self.STATE_STOP
            elif self.cur_state == self.STATE_RUN:
                prev_state = self.cur_state
                self.step()
            else:
                if self.cur_state != prev_state:
                    wx.CallAfter(self.update)
                prev_state = self.cur_state
                time.sleep(0.1)

    def step(self):
        self.run_inst()
        self.inc_pc()
        if self.get_pc() in self.cur_breakpoints:
            self.cur_state = self.STATE_STOP

    def step_into(self, _):
        self.cur_state = self.STATE_STEP

    def step_over(self, _):
        self.cur_state = self.STATE_STEP_OVER

    def run(self, _):
        self.cur_state = self.STATE_RUN

    def add_breakpoint(self, _):
        mem_loc_str = self.m_textCtrl1.GetValue()
        mem_loc = int(mem_loc_str, 16)
        self.cur_breakpoints.append(mem_loc)
        self.update()

    def remove_breakpoint(self, _):
        index = self.breakpoints.GetSelection()
        del self.cur_breakpoints[index]
        self.update()

    def break_on_label(self, _):
        index = self.labels.GetSelection()
        mem_loc = list(self.exec.exports.values())[index]
        self.cur_breakpoints.append(mem_loc+self.START_ADDR)
        self.update()

    def view_page(self, _):
        mem_loc_str = self.mem_page.GetValue()
        mem_loc = int(mem_loc_str, 16)
        self.cur_mem_page = mem_loc & 0xFFFFFF00
        self.update()

    def update(self):
        if self.exec is not None:
            self.labels.Set(list(map(lambda e: f"{e[0]}, {e[1]+self.START_ADDR:#010x}", self.exec.exports.items())))

            self.breakpoints.Set(list(map(lambda m: f"{m:#010x}", self.cur_breakpoints)))

            for val, label in zip(self.regs, [self.r0_val, self.r1_val, self.r2_val, self.r3_val, self.r4_val,
                                              self.r5_val, self.r6_val, self.r7_val, self.r8_val, self.r9_val,
                                              self.r10_val, self.r11_val, self.r12_val, self.r13_val, self.r14_val,
                                              self.r15_val]):
                val = struct.unpack("<I", val)[0]
                label.SetLabel(f"{val:#010x}")

            mem_loc = self.cur_mem_page
            for i in range(16):
                row_loc = mem_loc & 0xFFFFFFF0
                self.m_grid1.SetRowLabelValue(i, f"{row_loc:08x}")
                for j in range(16):
                    cell_loc = row_loc + j
                    cell_val = self.get_mem_byte(cell_loc)
                    self.m_grid1.SetCellValue(i, j, f"{cell_val:02x}")
                mem_loc += 0x10

            self.m_grid1.AutoSize()
            self.Layout()

            if self.cur_state == self.STATE_STOP:
                self.cur_inst.SetLabel(self.parse_inst())

    # Registers
    def get_reg(self, num):
        return struct.unpack("<I", self.regs[num])[0]

    def set_reg(self, num, val):
        self.regs[num] = bytearray(struct.pack("<I", val & 0xFFFFFFFF))

    # Memory
    def set_mem_dword(self, loc, val):
        val = struct.pack("<I", val & 0xFFFFFFFF)
        self.mem[loc] = val[0]
        self.mem[loc+1] = val[1]
        self.mem[loc+2] = val[2]
        self.mem[loc+3] = val[3]

    def set_mem_word(self, loc, val):
        val = struct.pack("<H", val & 0xFFFF)
        self.mem[loc] = val[0]
        self.mem[loc+1] = val[1]

    def set_mem_byte(self, loc, val):
        val = struct.pack("<B", val & 0xFF)
        self.mem[loc] = val[0]

    def get_mem_dword(self, loc):
        return struct.unpack("<I", self.mem[loc:loc+4])[0]

    def get_mem_word(self, loc):
        return struct.unpack("<H", self.mem[loc:loc+2])[0]

    def get_mem_byte(self, loc):
        return struct.unpack("<B", self.mem[loc:loc+1])[0]

    # Program counter
    def get_pc(self):
        return self.get_reg(15)

    def set_pc(self, val):
        return self.set_reg(15, val)

    def inc_pc(self, offset=1):
        self.set_pc(self.get_pc() + offset)

    # Flags
    def get_flag(self, flag):
        return 1 if self.get_reg(13) & flag else 0

    def set_flag(self, flag):
        self.set_reg(13, self.get_reg(13) | flag)

    def clear_flag(self, flag):
        self.set_reg(13, self.get_reg(13) & (~flag))

    def dec_reg(self, num, offset=1):
        self.set_reg(num, self.get_reg(num) - offset)

    def inc_reg(self, num, offset=1):
        self.set_reg(num, self.get_reg(num) + offset)

    # Stack
    def push_reg(self, num):
        self.dec_reg(14, 4)
        val = self.get_reg(num)
        self.set_mem_reg_indirect(14, 0, val)

    def pop_reg(self, num):
        val = self.get_mem_reg_indirect(14, 0)
        self.set_reg(num, val)
        self.inc_reg(14, 4)

    def push_mem(self, addr):
        self.dec_reg(14, 4)
        val = self.get_mem_dword(addr)
        self.set_mem_reg_indirect(14, 0, val)

    def pop_mem(self, addr):
        val = self.get_mem_reg_indirect(14, 0)
        self.set_mem_dword(addr, val)
        self.inc_reg(14, 4)

    # Indirect memory
    def set_mem_reg_indirect(self, reg, offset, val):
        reg_val = self.get_reg(reg)
        self.set_mem_dword(reg_val+offset, val)

    def get_mem_reg_indirect(self, reg, offset):
        reg_val = self.get_reg(reg)
        return self.get_mem_dword(reg_val+offset)

    # Peeking
    def peek_byte(self, offset=0):
        return int(self.mem[self.get_pc()+offset])

    def peek_word(self, offset=0):
        pc = self.get_pc()
        return struct.unpack("<H", self.mem[pc+offset:pc+offset+2])[0]

    def peek_dword(self, offset=0):
        pc = self.get_pc()
        return struct.unpack("<I", self.mem[pc+offset:pc+offset+4])[0]

    # Parameter decoding
    @staticmethod
    def get_reg_params(byte):
        reg_1 = byte & 0x0F
        reg_2 = (byte & 0xF0) >> 4
        return reg_1, reg_2

    def get_mem_address(self):
        mode = self.get_reg_params(self.peek_byte(1))[1]
        param = self.peek_dword(2)

        if mode == 0:
            return param
        elif mode == 1:
            return self.get_pc() + 2 - param
        elif mode == 2:
            return self.get_pc() + 2 + param
        elif mode == 3:
            reg = (param & 0xF0) >> 4
            reg_val = self.get_reg(reg)
            offset = (param & 0x0F) | ((param & 0xFFFFFF00) >> 4)
            if offset & 0x8000000:
                offset = offset - 0x10000000
            return reg_val + offset

    def get_mem_address_str(self):
        mode = self.get_reg_params(self.peek_byte(1))[1]
        param = self.peek_dword(2)

        if mode == 0:
            return f"${param:08x}"
        elif mode == 1:
            addr = self.get_pc() + 2 - param
            return f"${addr:08x}"
        elif mode == 2:
            addr = self.get_pc() + 2 + param
            return f"${addr:08x}"
        elif mode == 3:
            reg = (param & 0xF0) >> 4
            reg_val = self.get_reg(reg)
            offset = (param & 0x0F) | ((param & 0xFFFFFF00) >> 4)
            if offset & 0x8000000:
                offset = offset - 0x10000000
            return f"{offset}[%r{reg}]"

    def get_export_for_address(self, addr):
        for l, v in self.exec.exports.items():
            if v+self.START_ADDR == addr:
                return f"({l})"
        return ""

    def get_inst(self):
        return self.peek_byte(0)

    def is_subroutine(self):
        return self.get_inst() == 0x45

    def addr_after_subroutine(self):
        return self.get_pc() + 6

    # Arithmetic flags
    def set_carry_from_result(self, res):
        if res > 0xFFFFFFFF:
            self.set_flag(self.CARRY)
        else:
            self.clear_flag(self.CARRY)

    def set_zero_from_result(self, res):
        if res == 0:
            self.set_flag(self.ZERO)
        else:
            self.clear_flag(self.ZERO)

    def set_sign_from_result(self, res):
        if res & 0x80000000:
            self.set_flag(self.SIGN)
        else:
            self.clear_flag(self.SIGN)

    def set_overflow_from_result(self, op1, op2, res):
        if ((op1 ^ res) & (op2 ^ res)) & 0x80000000:
            self.set_flag(self.OVERFLOW)
        else:
            self.clear_flag(self.OVERFLOW)

    def set_flags_from_result(self, op1, op2, res):
        self.set_carry_from_result(res)
        self.set_zero_from_result(res & 0xFFFFFFFF)
        self.set_sign_from_result(res)
        self.set_overflow_from_result(op1, op2, res)

    # Disasembler
    def parse_inst(self):
        parser = self.insts.get(self.get_inst(), (self.parse_default, ))
        return parser[0]()

    def parse_default(self):
        inst = self.get_inst()
        self.cur_state = self.STATE_STOP
        return f"Invalid instruction ({inst:#06x})"

    # Running
    def run_inst(self):
        parser = self.insts.get(self.get_inst(), (None, self.run_default))
        return parser[1]()

    def run_default(self):
        pass

    def parse_mov_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mov #${const:08x}, %r{reg}"

    def run_mov_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.set_reg(reg, const)
        self.inc_pc(5)

    def parse_mov_mem_reg_short(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mov BYTE {addr}, %r{reg}"

    def run_mov_mem_reg_short(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        val = self.get_mem_byte(addr)
        self.set_reg(reg, val)
        self.inc_pc(5)

    def parse_mov_mem_reg_long(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mov WORD {addr}, %r{reg}"

    def run_mov_mem_reg_long(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        val = self.get_mem_word(addr)
        self.set_reg(reg, val)
        self.inc_pc(5)

    def parse_mov_mem_reg_double(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mov DWORD {addr}, %r{reg}"

    def run_mov_mem_reg_double(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        val = self.get_mem_dword(addr)
        self.set_reg(reg, val)
        self.inc_pc(5)

    def parse_mov_reg_mem_short(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mov %r{reg}, BYTE {addr}"

    def run_mov_reg_mem_short(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        val = self.get_reg(reg)
        self.set_mem_byte(addr, val)
        self.inc_pc(5)

    def parse_mov_reg_mem_long(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mov %r{reg}, WORD {addr}"

    def run_mov_reg_mem_long(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        val = self.get_reg(reg)
        self.set_mem_word(addr, val)
        self.inc_pc(5)

    def parse_mov_reg_mem_double(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mov %r{reg}, DWORD {addr}"

    def run_mov_reg_mem_double(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        val = self.get_reg(reg)
        self.set_mem_dword(addr, val)
        self.inc_pc(5)

    def parse_mov_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))
        return f"mov %r{reg1}, %r{reg2}"

    def run_mov_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))
        self.set_reg(reg2, self.get_reg(reg1))
        self.inc_pc()

    def parse_push_reg(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"push %r{reg}"

    def run_push_reg(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.push_reg(reg)
        self.inc_pc()

    def parse_push_mem(self):
        addr = self.get_mem_address_str()
        return f"push DOUBLE %r{addr}"

    def run_push_mem(self):
        addr = self.get_mem_address()
        self.push_mem(addr)

    def parse_pop_reg(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"pop %r{reg}"

    def run_pop_reg(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.pop_reg(reg)
        self.inc_pc()

    def parse_pop_mem(self):
        addr = self.get_mem_address_str()
        return f"pop DOUBLE %r{addr}"

    def run_pop_mem(self):
        addr = self.get_mem_address()
        self.pop_mem(addr)

    def parse_lea(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"lea {addr}, %r{reg}"

    def run_lea(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        self.set_reg(reg, addr)
        self.inc_pc(5)

    def run_add(self, op1, op2, carry=0):
        res = op2 + op1 + carry
        self.set_flags_from_result(op1, op2, res)
        return res

    def parse_add_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"add #${const:08x}, %r{reg}"

    def run_add_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op2 = self.get_reg(reg)
        res = self.run_add(const, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_adc_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"adc #${const:08x}, %r{reg}"

    def run_adc_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op2 = self.get_reg(reg)
        carry = self.get_flag(self.CARRY)
        res = self.run_add(const, op2, carry)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_add_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))
        return f"add %r{reg1}, %r{reg2}"

    def run_add_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_reg(reg1)
        op2 = self.get_reg(reg2)
        res = self.run_add(op1, op2)
        self.set_reg(reg2, res)
        self.inc_pc(1)

    def parse_adc_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))
        return f"adc %r{reg1}, %r{reg2}"

    def run_adc_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_reg(reg1)
        op2 = self.get_reg(reg2)
        carry = self.get_flag(self.CARRY)
        res = self.run_add(op1, op2, carry)
        self.set_reg(reg2, res)
        self.inc_pc(1)

    def parse_add_mem_reg_short(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"add BYTE {addr}, %r{reg}"

    def run_add_mem_reg_short(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_byte(addr)
        op2 = self.get_reg(reg)
        res = self.run_add(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_adc_mem_reg_short(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"adc BYTE {addr}, %r{reg}"

    def run_adc_mem_reg_short(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_byte(addr)
        op2 = self.get_reg(reg)
        carry = self.get_flag(self.CARRY)
        res = self.run_add(op1, op2, carry)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_add_mem_reg_long(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"add WORD {addr}, %r{reg}"

    def run_add_mem_reg_long(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_word(addr)
        op2 = self.get_reg(reg)
        res = self.run_add(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_adc_mem_reg_long(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"adc WORD {addr}, %r{reg}"

    def run_adc_mem_reg_long(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_word(addr)
        op2 = self.get_reg(reg)
        carry = self.get_flag(self.CARRY)
        res = self.run_add(op1, op2, carry)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_add_mem_reg_double(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"add DWORD {addr}, %r{reg}"

    def run_add_mem_reg_double(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_dword(addr)
        op2 = self.get_reg(reg)
        res = self.run_add(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_adc_mem_reg_double(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"adc DWORD {addr}, %r{reg}"

    def run_adc_mem_reg_double(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_dword(addr)
        op2 = self.get_reg(reg)
        carry = self.get_flag(self.CARRY)
        res = self.run_add(op1, op2, carry)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def run_sub(self, op1, op2, carry=1):
        res = (op2 + (~op1 & 0xFFFFFFFF) + carry)
        self.set_flags_from_result(~op1 & 0xFFFFFFFF, op2, res)
        return res & 0xFFFFFFFF

    def parse_sub_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sub #${const:08x}, %r{reg}"

    def run_sub_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op2 = self.get_reg(reg)
        res = self.run_sub(const, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_sbc_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sbc #${const:048}, %r{reg}"

    def run_sbc_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op2 = self.get_reg(reg)
        carry = self.get_flag(self.CARRY)
        res = self.run_sub(const, op2, carry)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_sub_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))
        return f"sub %r{reg1}, %r{reg2}"

    def run_sub_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_reg(reg1)
        op2 = self.get_reg(reg2)
        res = self.run_sub(op1, op2)
        self.set_reg(reg2, res)
        self.inc_pc()

    def parse_sbc_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))
        return f"sbc %r{reg1}, %r{reg2}"

    def run_sbc_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_reg(reg1)
        op2 = self.get_reg(reg2)
        carry = self.get_flag(self.CARRY)
        res = self.run_sub(op1, op2, carry)
        self.set_reg(reg2, res)
        self.inc_pc()

    def parse_sub_mem_reg_short(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sub BYTE {addr}, %r{reg}"

    def run_sub_mem_reg_short(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_byte(addr)
        op2 = self.get_reg(reg)
        res = self.run_sub(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_sbc_mem_reg_short(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sbc BYTE {addr}, %r{reg}"

    def run_sbc_mem_reg_short(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_byte(addr)
        op2 = self.get_reg(reg)
        carry = self.get_flag(self.CARRY)
        res = self.run_sub(op1, op2, carry)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_sub_mem_reg_long(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sub WORD {addr}, %r{reg}"

    def run_sub_mem_reg_long(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_word(addr)
        op2 = self.get_reg(reg)
        res = self.run_sub(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_sbc_mem_reg_long(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sbc WORD {addr}, %r{reg}"

    def run_sbc_mem_reg_long(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_word(addr)
        op2 = self.get_reg(reg)
        carry = self.get_flag(self.CARRY)
        res = self.run_sub(op1, op2, carry)
        self.set_reg(reg, res)
        self.inc_pc(5)


    def parse_sub_mem_reg_double(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sub DWORD {addr}, %r{reg}"

    def run_sub_mem_reg_double(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_dword(addr)
        op2 = self.get_reg(reg)
        res = self.run_sub(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_sbc_mem_reg_double(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sbc DWORD {addr}, %r{reg}"

    def run_sbc_mem_reg_double(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_dword(addr)
        op2 = self.get_reg(reg)
        carry = self.get_flag(self.CARRY)
        res = self.run_sub(op1, op2, carry)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_cmp_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"cmp #${const:08x}, %r{reg}"

    def run_cmp_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op2 = self.get_reg(reg)
        self.run_sub(const, op2)
        self.inc_pc(5)

    def parse_cmp_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))
        return f"cmp %r{reg1}, %r{reg2}"

    def run_cmp_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_reg(reg1)
        op2 = self.get_reg(reg2)
        self.run_sub(op1, op2)
        self.inc_pc()

    def parse_cmp_mem_reg_short(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"cmp BYTE {addr}, %r{reg}"

    def run_cmp_mem_reg_short(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_byte(addr)
        op2 = self.get_reg(reg)
        self.run_sub(op1, op2)
        self.inc_pc(5)

    def parse_cmp_mem_reg_long(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"cmp WORD {addr}, %r{reg}"

    def run_cmp_mem_reg_long(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_word(addr)
        op2 = self.get_reg(reg)
        self.run_sub(op1, op2)
        self.inc_pc(5)

    def parse_cmp_mem_reg_double(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"cmp DWORD {addr}, %r{reg}"

    def run_cmp_mem_reg_double(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_dword(addr)
        op2 = self.get_reg(reg)
        self.run_sub(op1, op2)
        self.inc_pc(5)

    def run_mul(self, op1, op2):
        res = op2 * op1
        self.set_flags_from_result(op1, op2, res)
        return res

    def run_div(self, op1, op2):
        res = op2 // op1
        self.set_flags_from_result(op1, op2, res)
        return res

    def run_mod(self, op1, op2):
        res = op2 % op1
        self.set_flags_from_result(op1, op2, res)
        return res

    def parse_mul_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mul #${const:08x}, %r{reg}"

    def run_mul_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op2 = self.get_reg(reg)
        res = self.run_mul(const, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_mul_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))
        return f"mul %r{reg1}, %r{reg2}"

    def run_mul_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_reg(reg1)
        op2 = self.get_reg(reg2)
        res = self.run_mul(op1, op2)
        self.set_reg(reg2, res)
        self.inc_pc(1)

    def parse_mul_mem_reg_short(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mul BYTE {addr}, %r{reg}"

    def run_mul_mem_reg_short(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_byte(addr)
        op2 = self.get_reg(reg)
        res = self.run_mul(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_mul_mem_reg_long(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mul WORD {addr}, %r{reg}"

    def run_mul_mem_reg_long(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_word(addr)
        op2 = self.get_reg(reg)
        res = self.run_mul(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_mul_mem_reg_double(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mul WORD {addr}, %r{reg}"

    def run_mul_mem_reg_double(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_dword(addr)
        op2 = self.get_reg(reg)
        res = self.run_mul(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_div_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"div #${const:08x}, %r{reg}"

    def run_div_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op2 = self.get_reg(reg)
        res = self.run_div(const, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_div_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))
        return f"div %r{reg1}, %r{reg2}"

    def run_div_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_reg(reg1)
        op2 = self.get_reg(reg2)
        res = self.run_div(op1, op2)
        self.set_reg(reg2, res)
        self.inc_pc(1)

    def parse_div_mem_reg_short(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"div BYTE {addr}, %r{reg}"

    def run_div_mem_reg_short(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_byte(addr)
        op2 = self.get_reg(reg)
        res = self.run_div(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_div_mem_reg_long(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"div WORD {addr}, %r{reg}"

    def run_div_mem_reg_long(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_word(addr)
        op2 = self.get_reg(reg)
        res = self.run_div(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_div_mem_reg_double(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"div DWORD {addr}, %r{reg}"

    def run_div_mem_reg_double(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_dword(addr)
        op2 = self.get_reg(reg)
        res = self.run_div(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_mod_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mod #${const:08x}, %r{reg}"

    def run_mod_const_reg(self):
        const = self.peek_dword(2)
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op2 = self.get_reg(reg)
        res = self.run_mod(const, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_mod_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))
        return f"mod %r{reg1}, %r{reg2}"

    def run_mod_reg_reg(self):
        reg1, reg2 = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_reg(reg1)
        op2 = self.get_reg(reg2)
        res = self.run_mod(op1, op2)
        self.set_reg(reg2, res)
        self.inc_pc(1)

    def parse_mod_mem_reg_short(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mod BYTE {addr}, %r{reg}"

    def run_mod_mem_reg_short(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_byte(addr)
        op2 = self.get_reg(reg)
        res = self.run_mod(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_mod_mem_reg_long(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mod WORD {addr}, %r{reg}"

    def run_mod_mem_reg_long(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_word(addr)
        op2 = self.get_reg(reg)
        res = self.run_mod(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_mod_mem_reg_double(self):
        addr = self.get_mem_address_str()
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"mod WORD {addr}, %r{reg}"

    def run_mod_mem_reg_double(self):
        addr = self.get_mem_address()
        reg, _ = self.get_reg_params(self.peek_byte(1))

        op1 = self.get_mem_dword(addr)
        op2 = self.get_reg(reg)
        res = self.run_mod(op1, op2)
        self.set_reg(reg, res)
        self.inc_pc(5)

    def parse_inc_reg(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"inc %r{reg}"

    def run_inc_reg(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.set_reg(reg, self.get_reg(reg)+1)
        self.inc_pc()

    def parse_inc_mem_short(self):
        addr = self.get_mem_address_str()
        return f"inc BYTE {addr}"

    def run_inc_mem_short(self):
        addr = self.get_mem_address()
        self.set_mem_byte(addr, self.get_mem_byte(addr)+1)
        self.inc_pc(5)

    def parse_inc_mem_long(self):
        addr = self.get_mem_address_str()
        return f"inc WORD {addr}"

    def run_inc_mem_long(self):
        addr = self.get_mem_address()
        self.set_mem_word(addr, self.get_mem_word(addr)+1)
        self.inc_pc(5)

    def parse_inc_mem_double(self):
        addr = self.get_mem_address_str()
        return f"inc DWORD {addr}"

    def run_inc_mem_double(self):
        addr = self.get_mem_address()
        self.set_mem_dword(addr, self.get_mem_dword(addr)+1)
        self.inc_pc(5)

    def parse_dec_reg(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"dec %r{reg}"

    def run_dec_reg(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.set_reg(reg, self.get_reg(reg)-1)
        self.inc_pc(1)

    def parse_dec_mem_short(self):
        addr = self.get_mem_address_str()
        return f"dec BYTE {addr}"

    def run_dec_mem_short(self):
        addr = self.get_mem_address()
        self.set_mem_byte(addr, self.get_mem_byte(addr)-1)
        self.inc_pc(5)

    def parse_dec_mem_long(self):
        addr = self.get_mem_address_str()
        return f"dec WORD {addr}"

    def run_dec_mem_long(self):
        addr = self.get_mem_address()
        self.set_mem_word(addr, self.get_mem_word(addr)-1)
        self.inc_pc(5)

    def parse_dec_mem_double(self):
        addr = self.get_mem_address_str()
        return f"dec DWORD {addr}"

    def run_dec_mem_double(self):
        addr = self.get_mem_address()
        self.set_mem_dword(addr, self.get_mem_dword(addr)-1)
        self.inc_pc(5)

    def parse_neg_reg(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"neg %r{reg}"

    def run_neg_reg(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.set_reg(reg, (~self.get_reg(reg))+1)
        self.inc_pc()

    def parse_neg_mem_short(self):
        addr = self.get_mem_address_str()
        return f"neg BYTE {addr}"

    def run_neg_mem_short(self):
        addr = self.get_mem_address()
        self.set_mem_byte(addr, (~self.get_mem_byte(addr))+1)
        self.inc_pc(5)

    def parse_neg_mem_long(self):
        addr = self.get_mem_address_str()
        return f"neg WORD {addr}"

    def run_neg_mem_long(self):
        addr = self.get_mem_address()
        self.set_mem_word(addr, (~self.get_mem_word(addr))+1)
        self.inc_pc(5)

    def parse_neg_mem_double(self):
        addr = self.get_mem_address_str()
        return f"neg DWORD {addr}"

    def run_neg_mem_double(self):
        addr = self.get_mem_address()
        self.set_mem_dword(addr, (~self.get_mem_dword(addr))+1)
        self.inc_pc(5)

    def parse_call(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"call {addr} {label}"

    def run_call(self):
        addr = self.get_mem_address()
        self.inc_pc(5)
        self.push_reg(15)
        self.set_pc(addr - 1)

    def parse_call_native(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"calln {addr} {label}, %r{reg}"

    def raw_read(self):
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        tty.setraw(sys.stdin.fileno())
        ch = sys.stdin.read(1)
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return ch

    def run_call_native(self):
        addr = self.get_mem_address() & 0xFFFF
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.inc_pc(5)

        if addr == 0xFFEE:
            sys.stdout.write(chr(self.get_reg(reg) & 0xFF))
            sys.stdout.flush()
        elif addr == 0xFFE0:
            char = self.raw_read()
            self.set_reg(reg, ord(char[0]))

    def parse_jump(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"jmp {addr} {label}"

    def run_jump(self):
        addr = self.get_mem_address()
        self.set_pc(addr - 1)

    def parse_jump_zero(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"jze {addr} {label}"

    def run_jump_zero(self):
        addr = self.get_mem_address()

        if not self.get_flag(self.ZERO):
            self.inc_pc(5)
        else:
            self.set_pc(addr - 1)

    def parse_jump_not_zero(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"jnz {addr} {label}"

    def run_jump_not_zero(self):
        addr = self.get_mem_address()

        if self.get_flag(self.ZERO):
            self.inc_pc(5)
        else:
            self.set_pc(addr - 1)

    def parse_jump_above_equal(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"jae {addr} {label}"

    def parse_jump_above(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"ja {addr} {label}"

    def run_jump_above(self):
        addr = self.get_mem_address()

        if self.get_flag(self.CARRY):
            self.inc_pc(5)
        else:
            self.set_pc(addr - 1)

    def run_jump_above_equal(self):
        addr = self.get_mem_address()

        if self.get_flag(self.CARRY) and not self.get_flag(self.ZERO):
            self.inc_pc(5)
        else:
            self.set_pc(addr - 1)

    def parse_jump_below(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"jb {addr} {label}"

    def run_jump_below(self):
        addr = self.get_mem_address()

        if self.get_flag(self.ZERO) or not self.get_flag(self.CARRY):
            self.inc_pc(3)
        else:
            self.set_pc(addr - 1)

    def parse_jump_below_equal(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"jbe {addr} {label}"

    def run_jump_below_equal(self):
        addr = self.get_mem_address()

        if not self.get_flag(self.CARRY):
            self.inc_pc(5)
        else:
            self.set_pc(addr - 1)

    def parse_jump_lesser(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"jl {addr} {label}"

    def run_jump_lesser(self):
        addr = self.get_mem_address()

        if self.get_flag(self.OVERFLOW) ^ self.get_flag(self.SIGN) or self.get_flag(self.ZERO):
            self.inc_pc(5)
        else:
            self.set_pc(addr - 1)

    def parse_jump_lesser_equal(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"jle {addr} {label}"

    def run_jump_lesser_equal(self):
        addr = self.get_mem_address()

        if self.get_flag(self.OVERFLOW) ^ self.get_flag(self.SIGN):
            self.inc_pc(5)
        else:
            self.set_pc(addr - 1)

    def parse_jump_greater(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"jg {addr} {label}"

    def run_jump_greater(self):
        addr = self.get_mem_address()

        if not (self.get_flag(self.OVERFLOW) ^ self.get_flag(self.SIGN)):
            self.inc_pc(5)
        else:
            self.set_pc(addr - 1)

    def parse_jump_greater_equal(self):
        addr = self.get_mem_address_str()
        addr_num = self.get_mem_address()
        label = self.get_export_for_address(addr_num)
        return f"jge {addr} {label}"

    def run_jump_greater_equal(self):
        addr = self.get_mem_address()

        if not ((self.get_flag(self.OVERFLOW) ^ self.get_flag(self.SIGN)) or self.get_flag(self.ZERO)):
            self.inc_pc(5)
        else:
            self.set_pc(addr - 1)

    def parse_set_zero(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sze %r{reg}"

    def run_set_zero(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.inc_pc(1)

        if not self.get_flag(self.ZERO):
            self.set_reg(reg, 0)
        else:
            self.set_reg(reg, 1)

    def parse_set_not_zero(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sne %r{reg}"

    def run_set_not_zero(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.inc_pc(1)

        if self.get_flag(self.ZERO):
            self.set_reg(reg, 0)
        else:
            self.set_reg(reg, 1)

    def parse_set_above_equal(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sae %r{reg}"

    def parse_set_above(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sa %r{reg}"

    def run_set_above(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.inc_pc(1)

        if self.get_flag(self.CARRY):
            self.set_reg(reg, 0)
        else:
            self.set_reg(reg, 1)

    def run_set_above_equal(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.inc_pc(1)

        if self.get_flag(self.CARRY) and not self.get_flag(self.ZERO):
            self.set_reg(reg, 0)
        else:
            self.set_reg(reg, 1)

    def parse_set_below(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sb %r{reg}"

    def run_set_below(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.inc_pc(1)

        if self.get_flag(self.ZERO) or not self.get_flag(self.CARRY):
            self.set_reg(reg, 0)
        else:
            self.set_reg(reg, 1)

    def parse_set_below_equal(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sbe %r{reg}"

    def run_set_below_equal(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.inc_pc(1)

        if not self.get_flag(self.CARRY):
            self.set_reg(reg, 0)
        else:
            self.set_reg(reg, 1)

    def parse_set_lesser(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sl %r{reg}"

    def run_set_lesser(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.inc_pc(1)

        if self.get_flag(self.OVERFLOW) ^ self.get_flag(self.SIGN) or self.get_flag(self.ZERO):
            self.set_reg(reg, 0)
        else:
            self.set_reg(reg, 1)

    def parse_set_lesser_equal(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sle %r{reg}"

    def run_set_lesser_equal(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.inc_pc(1)

        if self.get_flag(self.OVERFLOW) ^ self.get_flag(self.SIGN):
            self.set_reg(reg, 0)
        else:
            self.set_reg(reg, 1)

    def parse_set_greater(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sg %r{reg}"

    def run_set_greater(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.inc_pc(1)

        if not (self.get_flag(self.OVERFLOW) ^ self.get_flag(self.SIGN)):
            self.set_reg(reg, 0)
        else:
            self.set_reg(reg, 1)

    def parse_set_greater_equal(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        return f"sge %r{reg}"

    def run_set_greater_equal(self):
        reg, _ = self.get_reg_params(self.peek_byte(1))
        self.inc_pc(1)

        if not ((self.get_flag(self.OVERFLOW) ^ self.get_flag(self.SIGN)) or self.get_flag(self.ZERO)):
            self.set_reg(reg, 0)
        else:
            self.set_reg(reg, 1)

    @staticmethod
    def parse_return():
        return f"ret"

    def run_return(self):
        self.pop_reg(15)

    @staticmethod
    def parse_exit():
        return f"exit"

    def run_exit(self):
        self.cur_state = self.STATE_STOP
        self.set_pc(0xFFFFFFFF)


if __name__ == '__main__':
    app = wx.App()
    frm = Emulator(None, title='VM Emulator', size=(1200, 600))
    frm.Show()
    app.MainLoop()
