clc
clear all
close all

load('bf.mat');
load('bg.mat');
%Task 1
%system parameters
d = 7.12*10^(-3);
D = 38.5*10^(-3);
n = 12;
phi = 0;
T = 100000/48000;
t = linspace(0,T,100000);
fs=48000;
N=100000;
df=fs/N;

figure(1);
plot(t,bg(:,2));
xlabel('Time(s)');
ylabel('Amplitude');
title('tacho');

figure(2);
plot(t,bg(:,1));
xlabel('Time(s)');
ylabel('Amplitude');
title('vib');

[pk,tpk] = findpeaks(bg(:,2),t,'MinPeakProminence',0.6);

fr = 1/((tpk(length(pk))-tpk(1))/(length(pk)-1));
BPFO = n*fr/2*(1-d/D*cos(phi));%Outer race
BPFI = n*fr/2*(1+d/D*cos(phi));%Inner race
FTF = fr/2*(1-d/D*cos(phi));%Cage
BSF = fr*D/2/d*(1-(d/D*cos(phi))^2);%Rolling element

%Task 2
[Gxxf,f] = pwelch(bf(:,1),1024,512,1024,48000); 
[Gxxg,f] = pwelch(bg(:,1),1024,512,1024,48000);
Gxxflog = 20*log10(Gxxf/(10^(-6)));
Gxxglog = 20*log10(Gxxg/(10^(-6)));

figure(3);
plot(f,Gxxflog)
hold on
plot(f,Gxxglog);
legend('Fault Bearing','Good Bearing');
xlabel('Frequency(Hz)');
ylabel('PSD(dB)');

%Task 3:


bF=bf(:,1);
bF1=fft(bF);
bF2=zeros(4000,1);
for ii=1:2000
   bF2(ii,1)=bF1((31250+ii),1);%15000Hz
end
bF3=ifft(bF2);
bF4=(abs(bF3)).^2;
bF5=fft(bF4);
f=(0:length(bF5)-1)*df;

figure(4)
plot(f,abs(bF5));
xlim([0 400]);
xlabel('Frequency(Hz)');
ylabel('Amplitude');
title('Squared Envelope Spectrum of Fault Condition')

bG=bg(:,1);
bG1=fft(bG);
bG2=zeros(4000,1);
for ii=1:2000
   bG2(ii,1)=bG1((31250+ii),1);
end
bG3=ifft(bG2);
bG4=(abs(bG3)).^2;
bG5=fft(bG4);
f=(0:length(bG5)-1)*df;

figure(5)
plot(f,abs(bG5));
xlim([0 400]);
xlabel('Frequency(Hz)');
ylabel('Amplitude');
title('Squared Envelope Spectrum of Good Condition')