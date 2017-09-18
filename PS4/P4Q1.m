clc;
clear;
%Task 1
load('VelocityData.mat')
x1 = Vdata_1(1:5000)/0.0602*9.8;
x2 = Vdata_2(1:5000)/0.0599*9.8;
t = linspace(0,0.1,5000);
figure(1);
plot(t,x1);
hold on;
plot(t,x2);
hold off
legend('Signal 1','Signal 2');
xlabel('t(s)');
ylabel('Calibrated Acceleration(m/s^2)');

%Task 2
Mean1 = mean(x1);%mean of signal 1
Mean2 = mean(x2);%mean of signal 2
Max1 = max(x1);
Min1 = min(x1);
Max2 = max(x2);
Min2 = min(x2);
PTP1 = Max1-Min1;%peak to peak of signal 1
PTP2 = Max2-Min2;%peak to peak of signal 2
RMS1 = rms(Vdata_1/0.0602*9.8);%RMS of signal 1
RMS2 = rms(Vdata_2/0.0599*9.8);%RMS of signal 1

%Task 3
as1 = xcorr(Vdata_1/0.0602*9.8,2500)/200000;
as2 = xcorr(Vdata_2/0.0599*9.8,2500)/200000;
t2 = linspace(-0.05,0.05,5001);
figure(2);
plot(t2,as1);
hold on
plot(t2,as2);
hold off
legend('Autocorrelation sequence 1','Autocorrelation sequence 2');
xlabel('Time Delay(s)');
ylabel('R_x_x');

%Task 5
[Gxx1,~] = pwelch(Vdata_1/0.0602*9.8,2^13,2^11,2^13,50000);
[Gxx2,f] = pwelch(Vdata_2/0.0599*9.8,2^13,2^11,2^13,50000);
figure(3);
loglog(f,Gxx1);
hold on
loglog(f,Gxx2);
axis([200 10^4 10^(-7) 10^(-1)]);
legend('Signal 1','Signal 2');
xlabel('Frequency(Hz)');
ylabel('PSD(dB/Hz)');

%Task 7
[Gxx3,~] = pwelch(Vdata_1/0.0602*9.8,2000,500,2000,50000);
[Gxx4,f2] = pwelch(Vdata_2/0.0599*9.8,2000,500,2000,50000);
figure(4);
loglog(f2,Gxx3);
hold on
loglog(f2,Gxx4);
axis([200 10^4 10^(-7) 10^(-1)]);
legend('Signal 1','Signal 2');
xlabel('Frequency(Hz)');
ylabel('PSD(dB/Hz)');

%Task 8
[cxy, f3] = mscohere(Vdata_1/0.0602*9.8,Vdata_2/0.0599*9.8,2^13,2^11,2^13,50000);
figure(5);
semilogx(cxy);
set(gca, 'XScale', 'log');
axis([200 10^4 0 1]);
xlabel('Frequency(Hz)');
ylabel('Coherence');