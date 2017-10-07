clc
clear all
close all

load('bf.mat');
load('bg.mat');

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
faxail = [0:N-1]*df;
%figure of the original signal
figure(1);%tacho of good bearing
plot(t,bg(:,2));
xlim([0 T])
xlabel('Time(s)');
ylabel('Amplitude(m/s^2)');
title('Tacho');

figure(2);%vibration of good bearing
plot(t,bg(:,1));
xlim([0 T])
xlabel('Time(s)');
ylabel('Amplitude(m/s^2)');
title('Acceleration(Good)');

figure(3);%vibration of fault bearing
plot(t,bf(:,1));
xlabel('Time(s)');
xlim([0 T])
ylabel('Amplitude(m/s^2)');
title('Acceleration(Fault)');

%find the peaks and their locations
[pk,tpk] = findpeaks(bf(:,2),t,'MinPeakProminence',0.6);
%The average shaft speed
fr = 1/((tpk(length(pk))-tpk(1))/(length(pk)-1));
%calculate bearing fault frequencies
BPFO = n*fr/2*(1-d/D*cos(phi));%Outer race
BPFI = n*fr/2*(1+d/D*cos(phi));%Inner race
FTF = fr/2*(1-d/D*cos(phi));%Cage
BSF = fr*D/2/d*(1-(d/D*cos(phi))^2);%Rolling element
%band pass filter
xg = bandpass_filter(bg(:,1),0,20000,fs);
xf = bandpass_filter(bf(:,1),0,20000,fs);
%PSD of bg and bf
[Gxxf,f] = pwelch(xf,1024,512,1024,48000); 
[Gxxg,f] = pwelch(xg,1024,512,1024,48000);
GxxfdB = 20*log10(Gxxf/(10^(-6)));
GxxgdB = 20*log10(Gxxg/(10^(-6)));
%plot and compare PSD
figure(4);
plot(f,GxxfdB)
hold on
plot(f,GxxgdB);
legend('Fault Bearing','Good Bearing');
xlabel('Frequency(Hz)');
ylabel('PSD(dB)');
title('Comparing of PSD');

figure(5);
plot(f,Gxxf)
hold on
plot(f,Gxxg);
legend('Fault Bearing','Good Bearing');
xlabel('Frequency(Hz)');
ylabel('Amplitude(m/s^2)');
title('Comparing of linear amplitude');


%Envenlope analysis, Hilbert transform of fault bearing
bF=bf(:,1);
bF1=fft(bF);
bF2=zeros(4000,1);
for ii=1:2000
   bF2(ii,1)=bF1((31250+ii),1);%15000Hz-15960Hz
end
bF3=ifft(bF2);
bF4=(abs(bF3)).^2;
bF5=fft(bF4);
f1=(0:length(bF5)-1)*df;

%plot envelope spectrum
figure(6)
plot(f1,abs(bF5));
xlim([0 400]);
xlabel('Frequency(Hz)');
ylabel('Amplitude');
title('Squared Envelope Spectrum of Fault Condition(15kHz-16kHz)')

%Envenlope analysis, Hilbert transform of good bearing
bG=bg(:,1);
bG1=fft(bG);
bG2=zeros(4000,1);
for ii=1:2000
   bG2(ii,1)=bG1((31250+ii),1);
end
bG3=ifft(bG2);
bG4=(abs(bG3)).^2;
bG5=fft(bG4);
f2=(0:length(bG5)-1)*df;

figure(7)
plot(f2,abs(bG5));
xlim([0 400]);
xlabel('Frequency(Hz)');
ylabel('Amplitude');
title('Squared Envelope Spectrum of Good Condition')

bF=bf(:,1);
bF1=fft(bF);
bF2=zeros(4000,1);
for ii=1:2000
   bF2(ii,1)=bF1((25000+ii),1);%12000Hz-12960Hz
end
bF3=ifft(bF2);
bF4=(abs(bF3)).^2;
bF5=fft(bF4);
f1=(0:length(bF5)-1)*df;

figure(8)
plot(f1,abs(bF5));
xlim([0 400]);
xlabel('Frequency(Hz)');
ylabel('Amplitude');
title('Squared Envelope Spectrum of Fault Condition(12kHz-13kHz)')