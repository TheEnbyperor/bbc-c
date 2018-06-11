from . import il
from . import spots


class Optimiser:
    def optimise_Add(self, commands, index, spotmap):
        c = commands[index]
        l = spotmap[c.left]
        r = spotmap[c.right]
        if isinstance(l, spots.LiteralSpot) and isinstance(r, spots.LiteralSpot):
            spotmap[c.output] = spots.LiteralSpot(l.value+r.value, c.output.type)
            del commands[index]
            index -= 1

        return commands, index+1, spotmap

    def optimise_Not(self, commands, index, spotmap):
        c = commands[index]
        e = spotmap[c.expr]
        if isinstance(e, spots.LiteralSpot):
            spotmap[c.output] = spots.LiteralSpot(~e.value, c.output.type)
            del commands[index]
            index -= 1

        return commands, index+1, spotmap

    def optimise_Set(self, commands, index, spotmap):
        c = commands[index]
        c2 = commands[index - 1]
        if not isinstance(c2, il.Set):
            for output in c2.outputs():
                output_spot = spotmap[output]
                for input in c.inputs():
                    input_spot = spotmap[input]
                    if input_spot == output_spot and input_spot.type == output_spot.type:
                        print(c2)
                        spotmap[output] = spotmap[c.output]
                        print(output, spotmap[output])
        else:
            del commands[index]
            index -= 1
            spotmap[c2.output] = spotmap[c.output]

        if isinstance(spotmap[c.value], spots.LiteralSpot) or isinstance(spotmap[c.value], spots.LabelMemorySpot):
            if c.output.type.is_const() and c.output.type == c.value.type:
                spotmap[c.output] = spotmap[c.value]
                del commands[index]
                index -= 1

        return commands, index+1, spotmap

    def optimise(self, commands, spotmap):
        i = 0
        while i < len(commands):
            if (i + 1) == len(commands):
                break
            type_name = type(commands[i]).__name__
            o = getattr(self, "optimise_{}".format(type_name), None)
            if o is not None:
                commands, i, spotmap = o(commands, i, spotmap)
            else:
                i += 1

        return commands, spotmap