clear;
clc;
close all;

%% --- อ่านภาพ ---
img = imread("Cross.pgm");
img = double(img);

[M,N] = size(img);

%% --- FFT ---
F = fftshift(fft2(img));

[u,v] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(u.^2 + v.^2);

%% =========================
% IDEAL LOW PASS FILTER
%% =========================

cutoff = [10 30 60];

figure;
for k = 1:3
    
    D0 = cutoff(k);
    
    H = double(D <= D0);
    
    G = F .* H;
    
    img_lpf = real(ifft2(ifftshift(G)));
    
    subplot(2,3,k);
    imshow(H,[]);
    title(["Ideal LPF D0=",num2str(D0)]);
    
    subplot(2,3,k+3);
    imshow(img_lpf,[]);
    title("Filtered Image");
end

%% =========================
% NON-IDEAL (Gaussian LPF)
%% =========================

figure;
for k = 1:3
    
    D0 = cutoff(k);
    
    H = exp(-(D.^2)/(2*(D0^2)));
    
    G = F .* H;
    
    img_gauss = real(ifft2(ifftshift(G)));
    
    subplot(2,3,k);
    imshow(H,[]);
    title(["Gaussian D0=",num2str(D0)]);
    
    subplot(2,3,k+3);
    imshow(img_gauss,[]);
    title("Gaussian Result");
end
pause