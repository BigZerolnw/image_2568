import matplotlib.pyplot as plt
from readpgm import read_pgm_p5_no_lib

# อ่านภาพ PGM
pgm = read_pgm_p5_no_lib('scaled_shapes.pgm')

data_2d = pgm['data']
maxval = pgm['maxval']

# รวม pixel เป็น 1D
pixels = []
for row in data_2d:
    for p in row:
        pixels.append(p)

# ===== สร้าง histogram แบบไม่พึ่ง plt =====
hist = [0] * (maxval + 1)
for p in pixels:
    hist[p] += 1

# ===== นับจำนวน object จาก histogram =====
object_count = 0
object_gray_levels = []

for gray in range(0, 255):   # ไม่รวม background
    if hist[gray] > 3400:
        object_count += 1
        object_gray_levels.append(gray)

print("Number of objects =", object_count)
print("Object gray levels =", object_gray_levels)

# ===== plot histogram =====
plt.figure()
plt.bar(range(maxval + 1), hist, width=1.0)
plt.title('Histogram of PGM Image')
plt.xlabel('Gray Level')
plt.ylabel('Number of Pixels')
plt.show()

#question 1.2
height = len(data_2d)
width = len(data_2d[0])

def compute_phi1(image, width, height, gray):
    # ---- raw moments ----
    m00 = 0
    m10 = 0
    m01 = 0

    for y in range(height):
        for x in range(width):
            if image[y][x] == gray:
                m00 += 1
                m10 += x
                m01 += y

    # center of mass
    x_hat = m10 / m00
    y_hat = m01 / m00

    # ---- central moments ----
    mu20 = 0.0
    mu02 = 0.0

    for y in range(height):
        for x in range(width):
            if image[y][x] == gray:
                mu20 += (x - x_hat) ** 2
                mu02 += (y - y_hat) ** 2

    # ---- normalized moments ----
    eta20 = mu20 / (m00 ** 2)
    eta02 = mu02 / (m00 ** 2)

    # invariant
    phi1 = eta20 + eta02
    return phi1


print("\nQuestion 1.2 Results:")
print("Gray Level   phi1")

phi1_values = []

for gray in object_gray_levels:
    phi1 = compute_phi1(data_2d, width, height, gray)
    phi1_values.append(phi1)
    print(f"{gray:5d}      {phi1:.6f}")