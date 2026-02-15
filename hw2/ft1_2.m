clear;
clc;

% --- อ่านภาพ ---
img = imread("Cross.pgm");
img = double(img);

% แปลง grayscale ถ้าเป็น RGB
if ndims(img) == 3
    img = mean(img,3);
end

[M,N] = size(img);

% --- แสดง original ---
figure;
imshow(img,[]);
title("Original Image (Unpadded)");

% --- pad ---
P = 256;
Q = 256;

padded = zeros(P,Q);

for i = 1:M
    for j = 1:N
        padded(i,j) = img(i,j);
    end
end

% --- FFT ---
F = fft2(padded);
F_shift = fftshift(F);

% --- amplitude ---
amp = zeros(P,Q);
for i = 1:P
    for j = 1:Q
        amp(i,j) = log(1 + abs(F_shift(i,j)));
    end
end

% --- phase ---
phase = zeros(P,Q);
for i = 1:P
    for j = 1:Q
        phase(i,j) = angle(F_shift(i,j));
    end
end

% --- shift amount ---
x0 = 20;
y0 = 30;

% --- สร้าง spectrum ใหม่จาก amplitude + phase ที่ถูกเลื่อน ---
G = zeros(P,Q);

for u = 1:P
    for v = 1:Q

        shift_phase = -2*pi*((u-1)*x0/P + (v-1)*y0/Q);

        new_phase = phase(u,v) + shift_phase;

        G(u,v) = abs(F_shift(u,v)) * exp(1j*new_phase);

    end
end

% --- inverse shift กลับ ---
G_unshift = ifftshift(G);

% --- inverse FFT ---
shifted_img = real(ifft2(G_unshift));

% --- แสดงผล ---
figure;

subplot(1,2,1);
imshow(padded,[]);
title("Original (Padded)");

subplot(1,2,2);
imshow(shifted_img,[]);
title("Shifted Image Multiplied By Complex Number (20,30)");

pause
