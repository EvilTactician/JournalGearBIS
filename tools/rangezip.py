"""Pulls the DBC files the tools need (Spell.dbc, AreaTable.dbc) out of AzerothCore's client-data archive, without downloading all of it.

usage: python3 rangezip.py Spell.dbc"""
import urllib.request, zipfile, io, sys, os
HERE = os.path.dirname(os.path.abspath(__file__))
BUILD = os.environ.get("GEARBIS_BUILD", os.path.join(HERE, "build"))
URL = "https://github.com/wowgaming/client-data/releases/download/v16/data.zip"
ctx = None
# resolve redirect once
req = urllib.request.Request(URL, method="HEAD")
final = urllib.request.urlopen(req, context=ctx).geturl()
class RangeFile(io.RawIOBase):
    def __init__(self, url):
        self.url, self.pos = url, 0
        r = urllib.request.urlopen(urllib.request.Request(url, headers={"Range": "bytes=0-0"}), context=ctx)
        self.size = int(r.headers["Content-Range"].split("/")[1])
    def seekable(self): return True
    def readable(self): return True
    def tell(self): return self.pos
    def seek(self, off, whence=0):
        self.pos = off if whence == 0 else (self.pos + off if whence == 1 else self.size + off)
        return self.pos
    def read(self, n=-1):
        if n is None or n < 0: n = self.size - self.pos
        if n == 0 or self.pos >= self.size: return b""
        end = min(self.size, self.pos + n) - 1
        r = urllib.request.urlopen(urllib.request.Request(self.url, headers={"Range": "bytes=%d-%d" % (self.pos, end)}), context=ctx)
        data = r.read(); self.pos += len(data); return data
    def readinto(self, b):
        d = self.read(len(b)); b[:len(d)] = d; return len(d)
f = io.BufferedReader(RangeFile(final), buffer_size=1 << 20)
z = zipfile.ZipFile(f)
want = sys.argv[1:]
names = [n for n in z.namelist() if n.lower().split("/")[-1] in [w.lower() for w in want]]
print(names)
os.makedirs(os.path.join(BUILD, "dbc"), exist_ok=True)
for n in names:
    open(os.path.join(BUILD, "dbc", n.split("/")[-1]), "wb").write(z.read(n))
    print("saved", n)
