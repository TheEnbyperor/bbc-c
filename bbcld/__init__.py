from . import linker


def link_object_files_static(objects, sta):
    link = linker.Linker(objects, sta)
    out, exa = link.link_static()
    return bytes(out), exa


def link_object_files_shared(objects, strip=False, staic=False):
    link = linker.Linker(objects, 0)
    out = link.link_shared(strip, staic)
    return bytes(out)
