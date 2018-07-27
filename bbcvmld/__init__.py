from . import linker
from . import parser


def link_object_files_static(obj):
    link = linker.Linker(obj)
    exec = link.link_static()
    return exec


def link_object_files_shared(objects, strip=False, static=False):
    link = linker.Linker(objects)
    out = link.link_shared(strip, static)
    return bytes(out)

