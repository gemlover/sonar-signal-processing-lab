fs=8000;
t=0:1/fs:1;
% x=sin(2*pi*1000*t);
% x=sin(2*pi*3000*t);
x = sin(2*pi*1000*t) + 0.5*randn(size(t));
[Pxx,f]=pwelch(x,[],[],[],fs);
plot(f,10*log10(Pxx));
xlabel('Hz');ylabel('dB');