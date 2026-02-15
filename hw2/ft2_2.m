pkg load image

% ---------- Utility ----------
function out = rms_error(a,b)
  a = double(a);
  b = double(b);
  out = sqrt(mean((a(:)-b(:)).^2));
end

function H = ideal_lp(M,N,D0)
  [u,v] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
  D = sqrt(u.^2 + v.^2);
  H = double(D <= D0);
end

function H = gaussian_lp(M,N,D0)
  [u,v] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
  D = sqrt(u.^2 + v.^2);
  H = exp(-(D.^2)/(2*(D0^2)));
end

function out = apply_fft_filter(img,H)
  F = fftshift(fft2(img));
  G = H .* F;
  out = real(ifft2(ifftshift(G)));
end

% ---------- Load images ----------
chess_clean = imread("Chess.pgm");
chess_noise = imread("Chess_noise.pgm");

opera_clean = imread("OperaHousePGM_256_256.pgm");
opera_noise = imread("OperaHousePGM_256_256_noise.pgm");

% convert to double
chess_clean = double(chess_clean);
chess_noise = double(chess_noise);
opera_clean = double(opera_clean);
opera_noise = double(opera_noise);

[M,N] = size(chess_noise);

cutoffs = [20 40 80];

printf("\n=== Chess Results ===\n");

for D0 = cutoffs

  % Ideal LP
  H = ideal_lp(M,N,D0);
  out = apply_fft_filter(chess_noise,H);
  err = rms_error(out,chess_clean);
  printf("Ideal LP cutoff=%d RMS=%.2f\n",D0,err);

  % Gaussian LP
  H = gaussian_lp(M,N,D0);
  out = apply_fft_filter(chess_noise,H);
  err = rms_error(out,chess_clean);
  printf("Gaussian LP cutoff=%d RMS=%.2f\n",D0,err);

end

% Median filters
printf("\nMedian Filter Chess:\n");
for k=[3 5 7]
  out = medfilt2(chess_noise,[k k]);
  err = rms_error(out,chess_clean);
  printf("Median size=%d RMS=%.2f\n",k,err);
end

% ---------- Opera ----------
[M,N] = size(opera_noise);

printf("\n=== Opera Results ===\n");

for D0 = cutoffs

  H = ideal_lp(M,N,D0);
  out = apply_fft_filter(opera_noise,H);
  err = rms_error(out,opera_clean);
  printf("Ideal LP cutoff=%d RMS=%.2f\n",D0,err);

  H = gaussian_lp(M,N,D0);
  out = apply_fft_filter(opera_noise,H);
  err = rms_error(out,opera_clean);
  printf("Gaussian LP cutoff=%d RMS=%.2f\n",D0,err);

end

printf("\nMedian Filter Opera:\n");
for k=[3 5 7]
  out = medfilt2(opera_noise,[k k]);
  err = rms_error(out,opera_clean);
  printf("Median size=%d RMS=%.2f\n",k,err);
end
