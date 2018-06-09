from . import spots


class Optimiser:
    def optimise_Not(self, commands, index, spotmap):
        c = commands[index]
        e = spotmap[c.expr]
        if isinstance(e, spots.LiteralSpot):
            spotmap[c.output] = spots.LiteralSpot(~e.value, c.output.type)
            del commands[index]

        return commands, spotmap

    def optimise_Set(self, commands, index, spotmap):
        c2 = commands[index]
        c = commands[index - 2]
        for output in c.outputs():
            output_spot = spotmap[output]
            for input in c2.inputs():
                input_spot = spotmap[input]
                if input_spot == output_spot and input_spot.type == output_spot.type:
                    spotmap[output] = spotmap[c2.outputs()[0]]

        return commands, spotmap

    def optimise(self, commands, spotmap):
        for i, c in enumerate(commands):
            if (i + 1) == len(commands):
                break
            type_name = type(c).__name__
            o = getattr(self, "optimise_{}".format(type_name), None)
            if o is not None:
                commands, spotmap = o(commands, i, spotmap)

        return commands, spotmap