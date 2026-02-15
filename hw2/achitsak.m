clear;
clc;

% --- อ่านภาพ ---
img = imread("syrDKF2t.jpg");
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

% --- แสดง spectrum ---
figure;

subplot(1,3,1);
imshow(padded,[]);
title("Padded Image");

subplot(1,3,2);
imshow(amp,[]);
title("Amplitude Spectrum");

subplot(1,3,3);
imshow(phase,[]);
title("Phase Spectrum");

pause;
