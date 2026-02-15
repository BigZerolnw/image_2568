% =========================================
% Convolution theorem verification
% spatial blur = frequency blur
% =========================================

clear;
clc;

%% =========================
% อ่านภาพ
%% =========================

img = imread("Chess.pgm");
img = double(img);

[M,N] = size(img);

%% =========================
% kernel blur 3x3
%% =========================

kernel = ones(3,3)/9;

pad = 1;

%% =========================
% (A) SPATIAL CONVOLUTION
%% =========================

pimg = zeros(M+2*pad,N+2*pad);

% padding
for i=1:M
    for j=1:N
        pimg(i+pad,j+pad) = img(i,j);
    end
end

blur_spatial = zeros(M,N);

for i=1:M
    for j=1:N
        sumv = 0;
        for u=1:3
            for v=1:3
                sumv += kernel(u,v)*pimg(i+u-1,j+v-1);
            end
        end
        blur_spatial(i,j) = sumv;
    end
end

%% =========================
% (B) FREQUENCY CONVOLUTION
%% =========================

% linear convolution size
P = M + 2;
Q = N + 2;

%% =========================
%% =========================

P = M + 2;
Q = N + 2;

img_pad = zeros(P,Q);
img_pad(1:M,1:N) = img;

H = zeros(P,Q);
H(1:3,1:3) = kernel;

% shift center kernel
H = circshift(H, [-1 -1]);

F = fft2(img_pad);
Hf = fft2(H);

G = F .* Hf;

conv_full = real(ifft2(G));

blur_freq = conv_full(2:M+1,2:N+1);


%% =========================
% difference check
%% =========================

diff_img = blur_spatial - blur_freq;

%% =========================
% plot
%% =========================

figure;

subplot(2,2,1);
imshow(img,[]);
title("Original");

subplot(2,2,2);
imshow(blur_spatial,[]);
title("Spatial Blur");

subplot(2,2,3);
imshow(blur_freq,[]);
title("Frequency Blur");


pause;
