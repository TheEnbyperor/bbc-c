from . import linker


def link_object_files(objects, sta):
    link = linker.Linker(objects)
    out, exa = link.link(sta)
    return bytes(out), exa
