clc
clear
load('bf.mat');
load('bg.mat');
fs=48000;
N=100000;
dfs=fs/N;
 
bF=bf(:,1);
bF1=fft(bF);
bF2=zeros(2000,1);
for ii=1:1000
    bF2(ii,1)=bF1((75000+ii),1);
end
bF3=ifft(bF2);
bF4=(abs(bF3)).^2;
bF5=fft(bF4);
f=(0:length(bF5)-1)*dfs;
figure(1)
plot(f,abs(bF5));
xlim([0 200]);
xlabel('Frequency(Hz)');
ylabel('Amplitude');
title('Squared Envelope Spectrum of Fault Condition')

bG=bg(:,1);
bG1=fft(bG);
bG2=zeros(2000,1);
for ii=1:1000
    bG2(ii,1)=bG1((75000+ii),1);
end
bG3=ifft(bG2);
bG4=(abs(bG3)).^2;
bG5=fft(bG4);
f=(0:length(bG5)-1)*dfs;
figure(2)
plot(f,abs(bG5));
xlim([0 200]);
xlabel('Frequency(Hz)');
ylabel('Amplitude');
title('Squared Envelope Spectrum of Good Condition')