clear;
clc;

% --- อ่านภาพ ---
img = imread("OperaHousePGM_256_256.pgm");
img = double(img);

[M,N] = size(img);

% --- pad ---
%P = 256;
%Q = 256;

P = 300
Q = 300
padded = zeros(P,Q);

for i = 1:M
    for j = 1:N
        padded(i,j) = img(i,j);
    end
end

% --- FFT ---
F = fftshift(fft2(padded));

mag = abs(F);
phase = angle(F);

%% ===============================
% 1.5.1 ไม่มี phase
%% ===============================

F_no_phase = mag;   % phase = 0

img_no_phase = real(ifft2(ifftshift(F_no_phase)));

%% ===============================
% 1.5.2 ไม่มี amplitude
%% ===============================

F_no_mag = zeros(P,Q);

for i = 1:P
    for j = 1:Q
        F_no_mag(i,j) = exp(1j*phase(i,j));
    end
end

img_no_mag = real(ifft2(ifftshift(F_no_mag)));

%% --- แสดงผล ---
figure;

subplot(1,3,1);
imshow(padded,[]);
title("Original (Padded)");

subplot(1,3,2);
imshow(img_no_phase,[]);
title("No Phase");

subplot(1,3,3);
imshow(img_no_mag,[]);
title("No Amplitude");

pause;
