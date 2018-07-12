from . import linker


def link_object_files_static(obj):
    link = linker.Linker(obj)
    exec = link.link_static()
    print(exec)

    return exec

