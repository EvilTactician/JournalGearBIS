import struct
def load(path):
    d = open(path, "rb").read()
    magic, nrec, nfield, rsize, ssize = struct.unpack("<4s4I", d[:20])
    recs = d[20:20 + nrec * rsize]
    strings = d[20 + nrec * rsize:]
    def s(off):
        e = strings.find(b"\0", off)
        return strings[off:e].decode("utf8", "replace")
    rows = {}
    for i in range(nrec):
        raw = recs[i * rsize:(i + 1) * rsize]
        u = struct.unpack("<%dI" % nfield, raw)
        rows[u[0]] = u
    return rows, s, nfield
def i32(v): return v - (1 << 32) if v >= 1 << 31 else v
