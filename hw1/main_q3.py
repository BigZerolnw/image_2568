import matplotlib.pyplot as plt
import numpy as np

# ---------- PGM P5 reader (no external library) ----------
def read_pgm_p5(filename):
    with open(filename, 'rb') as f:
        # Read header
        assert f.readline().strip() == b'P5'
        line = f.readline()
        while line.startswith(b'#'):
            line = f.readline()

        width, height = map(int, line.split())
        maxval = int(f.readline())

        # Read image data
        img = np.frombuffer(f.read(), dtype=np.uint8)
        img = img.reshape((height, width))

    return img, maxval

# ---------- Normalize for display ----------
def normalize(img):
    img = img.astype(float)
    min_val = img.min()
    max_val = img.max()
    if max_val - min_val == 0:
        return np.zeros_like(img)
    return (img - min_val) / (max_val - min_val)

# ---------- Read RGB component images ----------
r, _ = read_pgm_p5("SanFranPeak_red.pgm")
g, _ = read_pgm_p5("SanFranPeak_green.pgm")
b, _ = read_pgm_p5("SanFranPeak_blue.pgm")

# ---------- Algebraic combinations ----------
gray = (r + g + b) / 3
excess_green = 2*g - r - b
red_blue_diff = r - b
veg_balance = g - (r + b) / 2
sky_emphasis = b - r

# ---------- Normalize results ----------
gray_n = normalize(gray)
eg_n = normalize(excess_green)
rb_n = normalize(red_blue_diff)
vb_n = normalize(veg_balance)
sky_n = normalize(sky_emphasis)

# ---------- Plot results ----------
plt.figure(figsize=(15, 10))

plt.subplot(2, 3, 1)
plt.imshow(gray_n, cmap='gray')
plt.title("(r + g + b) / 3 (Grayscale)")
plt.axis("off")

plt.subplot(2, 3, 2)
plt.imshow(eg_n, cmap='gray')
plt.title("2g - r - b (Excess Green)")
plt.axis("off")

plt.subplot(2, 3, 3)
plt.imshow(rb_n, cmap='gray')
plt.title("r - b (Red - Blue)")
plt.axis("off")

plt.subplot(2, 3, 4)
plt.imshow(vb_n, cmap='gray')
plt.title("g - (r + b) / 2")
plt.axis("off")

plt.subplot(2, 3, 5)
plt.imshow(sky_n, cmap='gray')
plt.title("b - r (Sky Emphasis)")
plt.axis("off")

plt.tight_layout()
plt.show()
