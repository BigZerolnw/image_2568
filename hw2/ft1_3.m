clear;
clc;

% --- อ่านภาพ ---
img = imread("Cross.pgm");
img = double(img);

[M,N] = size(img);

% --- หมุน 30 องศา ---
theta = 30*pi/180;

cx = M/2;
cy = N/2;

rot = zeros(M,N);

for x = 1:M
    for y = 1:N

        % shift center
        xt = x - cx;
        yt = y - cy;

        % inverse rotation
        xr =  xt*cos(theta) + yt*sin(theta);
        yr = -xt*sin(theta) + yt*cos(theta);

        % shift back
        xr = round(xr + cx);
        yr = round(yr + cy);

        if xr>=1 && xr<=M && yr>=1 && yr<=N
            rot(x,y) = img(xr,yr);
        end

    end
end

% --- FFT ---
F = fftshift(fft2(rot));

amp = log(1 + abs(F));
phase = angle(F);

% --- แสดงผล ---
figure;

subplot(2,2,1);
imshow(img,[]);
title("Original");

subplot(2,2,2);
imshow(rot,[]);
title("Rotated 30 deg");

subplot(2,2,3);
imshow(amp,[]);
title("Amplitude Spectrum");

subplot(2,2,4);
imshow(phase,[]);
title("Phase Spectrum");

pause;
