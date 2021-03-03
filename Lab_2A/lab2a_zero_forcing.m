%% Zero Forcing Receiver
clear all
load('2User2AntennaBS.mat');
%% Make vectors.
[y1, y2] = take_real(y1, y2);

%% Account for any delay.
[d1, lags1, cor1] = find_delay(y1, x1);
[d2, lags2, cor2] = find_delay(y2, x2);

% delay the signals
y1 = y1(d1:end);
y2 = y2(d2:end);

%% Creating matrices.
x = [x1'; x2'];
y = [y1'; y2'];
%% Estimate the channel response.
H = estimate_channel_response(x1, x2, y1, y2, pulseWidth);

%% Calculate the weight vectors.
% we know that H* x w = [1; 0] for x1
w1 = H' \ [1; 0];

% we know that H* x w = [0; 1] for x2
w2 = H' \ [0; 1];

%% Apply the weight vectors.
x1_hat = w1' * y;
x2_hat = w2' * y;

%% Downsample the data.
starting = ceil(pulseWidth/2) + 1;
x1_hat_round = sign(round(x1_hat));
x1_hat_down = x1_hat_round(starting:pulseWidth:end);

x2_hat_round = sign(round(x2_hat));
x2_hat_down = x2_hat_round(starting:pulseWidth:end);

%%
x1 = x1(starting:pulseWidth:end);
x2 = x2(starting:pulseWidth:end);
%% Calculate the error.
error_tx1 = calculate_error(x1_hat_down, x1);
error_tx2 = calculate_error(x2_hat_down, x2);

figure
hold on
stem(x1(1000:1200));
stem(x1_hat_down(1000:1200));
title('Received and Transmitted Data from Transmitter 1 With Zero Forcing Receiver')
xlabel('Samples')
ylabel('Amplitude')
legend('Transmitted', 'Received')

figure
hold on
stem(x2(1000:1200));
stem(x2_hat_down(1000:1200));
title('Received and Transmitted Data from Transmitter 2 With Zero Forcing Receiver')
xlabel('Samples')
ylabel('Amplitude')
legend('Transmitted', 'Received')
hold off