from . import insts


class Assemble:
    def __init__(self, prog, addr):
        self.prog = prog
        self.addr = addr
        self.labels = {}

    def fill_labels(self):
        addr = self.addr
        for i in self.prog.insts:
            if len(i.labels) > 0:
                for l in i.labels:
                    self.labels[l] = addr
            addr += len(i)
        for n, i in enumerate(self.prog.insts):
            if isinstance(i.value, insts.LabelVal):
                self.prog.insts[n].value = insts.MemVal(self.labels[i.value.label])

    def assemble(self):
        out = []
        addr = self.addr
        for i in self.prog.insts:
            out.extend(i.gen(addr))
            addr += len(i)

        return out, self.labels["_start"]
