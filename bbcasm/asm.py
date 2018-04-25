from . import insts


class Assemble:
    def __init__(self, insts, addr):
        self.insts = insts
        self.addr = addr
        self.labels = {}

    def fill_labels(self):
        addr = self.addr
        for i in self.insts:
            if i.label is not None:
                self.labels[i.label] = addr
            addr += len(i)
        for n, i in enumerate(self.insts):
            if isinstance(i.value, insts.LabelVal):
                self.insts[n].value = insts.MemVal(self.labels[i.value.label])

    def assemble(self):
        out = []
        addr = self.addr
        for i in self.insts:
            out.extend(i.gen(addr))
            addr += len(i)

        return out, self.labels["_start"]
