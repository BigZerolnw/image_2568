#use library Cameraman
import cv2
import matplotlib.pyplot as plt

# อ่านภาพ PGM
img = cv2.imread("Cameraman.pgm", cv2.IMREAD_GRAYSCALE)
img1 = cv2.imread("SEM256_256.pgm", cv2.IMREAD_GRAYSCALE)
# img = cv2.imread("SEM256_256.pgm", cv2.IMREAD_GRAYSCALE)

# Histogram Equalization
eq = cv2.equalizeHist(img)

# แสดงภาพ + histogram
plt.figure(figsize=(12,6))

plt.subplot(2,2,1)
plt.imshow(img, cmap='gray')
plt.title("Original Image")
plt.axis("off")

plt.subplot(2,2,2)
plt.imshow(eq, cmap='gray')
plt.title("Histogram Equalized Image")
plt.axis("off")

plt.subplot(2,2,3)
plt.hist(img.flatten(), bins=256, range=(0,255))
plt.title("Original Histogram")

plt.subplot(2,2,4)
plt.hist(eq.flatten(), bins=256, range=(0,255))
plt.title("Equalized Histogram")

###

# plt.subplot(2,2,1)
# plt.imshow(img1, cmap='gray')
# plt.title("Original Image")
# plt.axis("off")

# plt.subplot(2,2,2)
# plt.imshow(eq, cmap='gray')
# plt.title("Histogram Equalized Image")
# plt.axis("off")

# plt.subplot(2,2,3)
# plt.hist(img1.flatten(), bins=256, range=(0,255))
# plt.title("Original Histogram")

# plt.subplot(2,2,4)
# plt.hist(eq.flatten(), bins=256, range=(0,255))
# plt.title("Equalized Histogram")

plt.tight_layout()
plt.show()
