from . import linker


def link_object_files_static(obj):
    link = linker.Linker(obj)
    exec = link.link_static()
    return exec


def link_object_files_shared(objects, strip=False):
    link = linker.Linker(objects)
    out = link.link_shared(strip)
    return bytes(out)

