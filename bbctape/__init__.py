import numpy as np
import wave
import struct
import math
from PyCRC.CRCCCITT import CRCCCITT

SAMPLE_RATE = 44100
BAUD_RATE = 1500


def gen_sine(freq, cycles):
    x = np.arange((SAMPLE_RATE / freq) * cycles)
    s = np.sin(2 * np.pi * freq * x / SAMPLE_RATE)
    return s


def make_len(data, secs):
    return np.tile(data, int(SAMPLE_RATE / len(data) * secs))


def make_block(filename: str, lda, exa, blkn, prot, empt, lblk, data):
    data_len = len(data)
    out = bytearray()
    out.extend(filename.encode())
    out.append(0)
    out.extend(struct.pack("<L", lda))
    out.extend(struct.pack("<L", exa))
    out.extend(struct.pack("<H", blkn))
    out.extend(struct.pack("<H", data_len))
    out.append((1 & prot) + ((1 & empt) << 6) + ((1 & lblk) << 7))
    out.extend([0, 0, 0, 0])

    crc = CRCCCITT().calculate(bytes(out))
    out.extend(struct.pack(">H", crc))

    data_crc = CRCCCITT().calculate(bytes(data))
    out.extend(data)
    out.extend(struct.pack(">H", data_crc))

    return bytearray([0x2A]) + out


bit0 = gen_sine(BAUD_RATE, 1)
bit1 = gen_sine(BAUD_RATE * 2, 2)
stop_bit = gen_sine(BAUD_RATE * 2, 1.5)
start = make_len(bit1, 1.1)
block_end = make_len(bit1, 0.9)


def bytes_to_sample(byte):
    sample = []
    for b in byte:
        sample.extend(bit0)
        for i in range(8):
            bit = (b >> i) & 1
            if bit:
                sample.extend(bit1)
            else:
                sample.extend(bit0)
        sample.extend(stop_bit)
    return np.array(sample)


def make_file(w, file, lda, exa, prot, data):
    num_blocks = int(math.ceil(len(data) / 256))
    blocks = [start]
    for i in range(num_blocks):
        bdata = data[0+(i*256):256+(i*256)]
        block = make_block(file, lda, exa, i, prot, 0, (i == num_blocks-1), bdata)
        block = bytes_to_sample(block)
        blocks.append(block)
        blocks.append(block_end)
    blocks.append(start)
    sample = np.asarray(np.concatenate(blocks) * 0x7fff, dtype=np.int16)
    w.setframerate(SAMPLE_RATE)
    w.setnchannels(1)
    w.setsampwidth(2)
    w.setnframes(len(sample))
    w.writeframes(sample)
