close all; clear; clc;

% time = 0:0.1:100;
% volt = 2 * sawtooth(time, 1/2);
% plot(time, volt);

data = csvread('MFM_scheme3.csv',1,0);
time = data(:,1);
volt = data(:,2) * 2;
vd = ones(length(time), 1) * 0.05;
vs = zeros(length(time), 1);
figure;
% time = time(1:2000);
% volt = volt(1:2000);
plot(time, volt);

[vafe, Psat, ids] = get_AFE_state(time, volt, vd, vs);

eafe = 33.70;
tfe = 1e-7;

Psat = Psat + eafe * 8.85e-14 * vafe / tfe;

figure;
plot(time, Psat);

figure;
plot(vafe, Psat);

figure;
plot(time, vafe);

figure;
plot(volt, ids);
