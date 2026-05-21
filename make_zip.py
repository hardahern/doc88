import os
import sys
import zipfile

ROOT = os.path.join("dist", "doc88_extractor")
OUT = os.path.join("dist", "doc88_extractor_win64.zip")
SKIP_DIRS = {"docs", "logs"}
SKIP_FILES = {"config.json"}

if not os.path.isdir(ROOT):
    sys.exit(f"missing {ROOT}")

if os.path.exists(OUT):
    os.remove(OUT)

n = 0
with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as z:
    for dirpath, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for fname in filenames:
            if fname in SKIP_FILES:
                continue
            src = os.path.join(dirpath, fname)
            arc = os.path.relpath(src, "dist")
            z.write(src, arc)
            n += 1

size = os.path.getsize(OUT)
print(f"  wrote {n} files, {size/1024/1024:.1f} MB -> {OUT}")
