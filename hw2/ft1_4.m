clear;
clc;
%Down sample image
% --- อ่านภาพ ---
img = imread("Cross.pgm");
img = double(img);

[M,N] = size(img);

% --- Down-sample 2:1 ---
Md = M/2;
Nd = N/2;

down = zeros(Md,Nd);

for i = 1:Md
    for j = 1:Nd
        down(i,j) = img(2*i-1, 2*j-1);
    end
end

% --- FFT ---
F = fftshift(fft2(down));

amp = log(1 + abs(F));
phase = angle(F);

% --- แสดงผล ---
figure;

subplot(1,3,1);
imshow(down,[]);
title("Down-sampled 100x100");

subplot(1,3,2);
imshow(amp,[]);
title("Amplitude Spectrum");

subplot(1,3,3);
imshow(phase,[]);
title("Phase Spectrum");

pause;
