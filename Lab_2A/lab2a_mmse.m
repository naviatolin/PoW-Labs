clear all
load('2User2AntennaBS.mat');
%% Make vectors.
x1 = real(x1);
x2 = real(x2);
y1 = -1 * real(y1);
y2 = -1 * real(y2);
%% Account for any delay.
d1 = finddelay(x1, y1);
d2 = finddelay(x2, y2);
y1 = y1(d1:end);
y2 = y2(d2:end);

%% Creating matrices.
x = [x1'; x2'];
y = [y1'; y2'];
%% Estimate the channel response.
% Note: We are assuming noise is negligible.

% transmitter 1 transmits

% Note: last bit was infinity which is why I had to subtract 1 : unsure why

starting1 = 5001;
x1_1 = x1(starting1 : pulseWidth * 128 + starting1 - 1);
y1_1 = y1(starting1 : pulseWidth * 128 + starting1 - 1);
y2_1 = y2(starting1 : pulseWidth * 128 + starting1 - 1);

% transmitter 2 transmits
starting2 = starting1 + (pulseWidth * 128) + 5000;
x2_2 = x2(starting2 : pulseWidth * 128 + starting2 - 1);
y1_2 = y1(starting2 : pulseWidth * 128 + starting2 - 1);
y2_2 = y2(starting2 : pulseWidth * 128 + starting2 - 1);

% calculating the channel response
% when y1 is listening to x1 speak
h11 = mean(y1_1 ./ x1_1);
% when y2 is listening to x1 speak
h21 = mean(y2_1 ./ x1_1);

% when y1 is listening to x2 speak
h12 = mean(y1_2 ./ x2_2);
% when y2 is listening to x2 speak
h22 = mean(y2_2 ./ x2_2);

%% Creating the channel response matrix.
H = [h11 h12; h21 h22];

%% Calculate the weight vectors using MMSE.
lambda = var(y1);
w = H' * inv(H * H' + lambda*eye(2,2));
w1 = w(1,:)';
w2 = w(2,:)';

%% Apply the weight vectors.
x1_hat = w1' * y;
x2_hat = w2' * y;

x_hat = [x1_hat; x2_hat];

%% Calculate the error.
% look at the last 1024 data bits to calculate the error
intermediate_data_length = 128 * pulseWidth;
starting3 = 5000 + intermediate_data_length + 5000 + intermediate_data_length + 5000 + 1;
last_message_length = 1024*40;

% crop off the end of the data
x_check = x(:, starting3 : starting3 + last_message_length);
y_check = sign(y(:, starting3 : starting3 + last_message_length));

% sample in the middle of the pulse width
x_check = x_check(:, 20 : pulseWidth : end);
y_check = y_check(:, 20 : pulseWidth : end);

figure
hold on
stem(x_check(1,:));
stem(y_check(1,:));

figure
hold on
stem(x_check(2,:));
stem(y_check(2,:));

equality1 = (y_check(1,:) ~= x_check(1,:));
equality2 = (y_check(2,:) ~= x_check(2,:));
error_rate1 = sum(equality1)/length(x_check) 
error_rate2 = sum(equality2)/length(x_check) 