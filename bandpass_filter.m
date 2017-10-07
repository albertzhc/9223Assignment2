function xf = bandpass_filter(x,f1,f2,fs)

dt=1/fs;
n=length(x);
t=(0:n-1)*dt;
df=fs/n;
f1s=round(1+f1/df); %Filter cut-off frequencies rounded to sample number
f2s=round(1+f2/df);

X=fft(x);
Xf=zeros(n,1);
Xf(f1s:f2s)=X(f1s:f2s);
xf=2*real(ifft(Xf));


%% Now plot:
% figure
% plot(t,x)
% title('Original signal')
% figure
% plot(t,xf)
% title('Bandpass filtered signal');
