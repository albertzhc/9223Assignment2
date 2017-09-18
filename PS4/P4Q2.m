clc
clear
load('bf.mat');
load('bg.mat');

%Task 1
%system parameters
d = 7.12*10^(-3);
D = 38.5*10^(-3);
n = 12;
phi = 0;
tf = 100000/48000;
t = linspace(0,tf,100000);

figure(1);
plot(t,bg(:,2));
xlabel('Time(s)');
ylabel('Amplitude');
[pk,tpk] = findpeaks(bg(:,2),t,'MinPeakProminence',2);
fr = 1/((tpk(length(tpk))-tpk(1))/(length(tpk)-1));

BPFO = n*fr/2*(1-d/D*cos(phi));%Outer race
BPFI = n*fr/2*(1+d/D*cos(phi));%Inner race
FTF = fr/2*(1-d/D*cos(phi));%Cage
BSF = fr*D/2/d*(1-(d/D*cos(phi))^2);%Rolling element

%Task 2
[Gxxf,f] = pwelch(bf(:,1),1024,512,1024,48000);
[Gxxg,f] = pwelch(bg(:,1),1024,512,1024,48000);
Gxxflog = 20*log10(Gxxf/(10^(-6)));
Gxxglog = 20*log10(Gxxg/(10^(-6)));
figure(2);
plot(f,Gxxflog)
hold on 
plot(f,Gxxglog);
legend('Bearing with a fault','Bearing in good condition');
xlabel('Frequency(Hz)');
ylabel('PSD(dB)');