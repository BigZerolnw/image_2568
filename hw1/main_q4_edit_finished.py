import numpy as np
import matplotlib.pyplot as plt
import os

# -------------------------------
# Read PGM
# -------------------------------
def read_pgm_p5(filename):
    if not os.path.exists(filename):
        img = np.zeros((300, 400), dtype=np.uint8)
        for y in range(300):
            for x in range(400):
                if ((y // 40) + (x // 40)) % 2 == 0:
                    img[y, x] = 255
        return img

    with open(filename, 'rb') as f:
        assert f.readline().strip() == b'P5'
        line = f.readline()
        while line.startswith(b'#'):
            line = f.readline()
        w, h = map(int, line.split())
        f.readline()
        img = np.frombuffer(f.read(), dtype=np.uint8).reshape(h, w)
    return img


# -------------------------------
# Bilinear interpolation
# -------------------------------
def bilinear(img, x, y):
    h, w = img.shape
    if x < 0 or x >= w - 1 or y < 0 or y >= h - 1:
        return 0

    x0 = int(np.floor(x))
    y0 = int(np.floor(y))
    dx = x - x0
    dy = y - y0

    return (
        (1 - dx) * (1 - dy) * img[y0, x0] +
        dx * (1 - dy) * img[y0, x0 + 1] +
        (1 - dx) * dy * img[y0 + 1, x0] +
        dx * dy * img[y0 + 1, x0 + 1]
    )


# -------------------------------
# Local rotation (center only)
# -------------------------------
def local_rotate_ccw(src, max_angle_deg=30, radius=120):
    h, w = src.shape
    dst = np.zeros_like(src)

    cx = w / 2
    cy = h / 2

    for y in range(h):
        for x in range(w):
            dx = x - cx
            dy = y - cy
            r = np.sqrt(dx*dx + dy*dy)

            if r > radius:
                dst[y, x] = src[y, x]
                continue

            # weight decreases with distance
            wgt = 1 - r / radius
            theta = np.deg2rad(max_angle_deg * wgt)

            cos_t = np.cos(theta)
            sin_t = np.sin(theta)

            # backward mapping (CCW)
            src_x = cos_t * dx + sin_t * dy + cx
            src_y = -sin_t * dx + cos_t * dy + cy

            dst[y, x] = bilinear(src, src_x, src_y)

    return dst


# -------------------------------
# Main
# -------------------------------
img = read_pgm_p5("disOperaHouse.pgm")

out = local_rotate_ccw(
    img,
    max_angle_deg=-89,  # มุมสูงสุดตรงกลาง
    radius= 120         # รัศมีที่มีผล
)

plt.figure(figsize=(10, 5))
plt.subplot(1, 2, 1)
plt.imshow(img, cmap='gray')
plt.title("Original")
plt.axis("off")

plt.subplot(1, 2, 2)
plt.imshow(out, cmap='gray')
plt.title("Local Rotation (Center Only, CCW)")
plt.axis("off")

plt.tight_layout()
plt.show()
