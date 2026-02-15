pkg load control


num = [100];
den = [1 1 2 2 0  ];
sys = tf(num,den);

nyquist(sys);

pause