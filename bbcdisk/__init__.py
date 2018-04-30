from .tools import makedfs


File = makedfs.File


def files_to_disk(files):
    disk = makedfs.Disk()
    disk.new()

    cat = disk.catalogue()
    cat.write("", files)

    disk.file.seek(0, 0)
    return disk.file.read()
