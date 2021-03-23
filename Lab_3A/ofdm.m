%% Clear
clear all;

%% Estimate the channel
block_len = 64;
prefix_len = 16;
block_num = 100;

% generate channels in the frequency domain
training = gen_data(block_num, block_len);

% convert to the time domain
time_training = freq_to_time(training);

% add the cyclic prefix to the signal
prefix_training = prefix_long(time_training, block_len, prefix_len, block_num);

% pass the signal through the channel
received_training = nonflat_channel(prefix_training);

% find the delay
delay = find_delay(received_training, prefix_training);

% apply the delay
delayed_training = received_training(delay:end);

% crop the signal by the prefix length
cropped_training = crop_long(delayed_training, block_len, prefix_len, block_num);

% convert back to the frequency domain
rx_training = time_to_freq(cropped_training);

% estimate channel
h_multiple_run = rx_training./training;
H = mean(reshape(h_multiple_run, [block_num, block_len]));

%% Clear all
clear block_len block_num cropped_training delay delayed_training prefix_len prefix_training received_training rx_training time_training training h_multiple_run;

%% OFDM Process
block_len = 64;
prefix_len = 16;
block_num = 100;

% generate channels in the frequency domain
data = gen_data(block_num, block_len);

% convert to the time domain
time_data = freq_to_time(data);

% add the cyclic prefix to the signal
prefix_data = prefix_long(time_data, block_len, prefix_len, block_num);

% pass the signal through the channel
received_data = nonflat_channel(prefix_data);

% find the delay
delay = find_delay(received_data, prefix_data);

% apply the delay
delayed_data= received_data(delay:end);

% crop the signal by the prefix length
cropped_data = crop_long(delayed_data, block_len, prefix_len, block_num);

% convert back to the frequency domain
rx_data = time_to_freq(cropped_data);

% solve for x_hat
X_hat = estimate_signal(H, rx_data, block_num);

%% Compute the error.
error = compute_error(X_hat, data);
