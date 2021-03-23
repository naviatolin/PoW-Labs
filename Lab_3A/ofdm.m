%% Clear
clear all;

%% Estimate the channel
block_len = 64;
prefix_len = 16;
block_num = 2;

% generate channels in the frequency domain
tx_train = gen_data(block_num, block_len);

% take the ifft and add the cyclic prefix to the signal
prefixed_train = prefix_long(tx_train, block_len, prefix_len, block_num);

% pass the signal through the channel
rx_train = nonflat_channel(prefixed_train);

% find the delay
delay = find_delay(rx_train, prefixed_train);

% apply the delay
rx_delay = rx_train(delay:end);

% crop the signal by the prefix length
rx_hat = crop_long(rx_delay, block_len, prefix_len, block_num);

% estimate channel
h_multiple_run = rx_hat./tx_train;
h_stacked = reshape(h_multiple_run, [block_num, block_len]);
H = mean(h_stacked);

%% Clear all but channel estimate
clearvars -except H

%% OFDM Process
block_len = 64;
prefix_len = 16;
block_num = 1000;

% generate channels in the frequency domain
tx = gen_data(block_num, block_len);

% add the cyclic prefix to the signal
prefixed_tx = prefix_long(tx, block_len, prefix_len, block_num);

% pass the signal through the channel
rx = nonflat_channel(prefixed_tx);

% find the delay
delay = find_delay(rx, prefixed_tx);

% apply the delay
rx_delay = rx(delay:end);

% crop the signal by the prefix length
rx_data = crop_long(rx_delay, block_len, prefix_len, block_num);

% solve for x_hat
X = estimate_signal(H, rx_data, block_num);

X_hat = sign(real(X));


% Compute the error.
error = compute_error(X_hat, tx)

%%
figure
hold on
stem(tx(1:64), 'LineWidth', 1, 'Color', 'red')
stem(rx_data(1:64), 'LineWidth', 1, 'Color', 'blue')
ylim([-1.35 1.35])
xlabel('Frequency Channels')
ylabel('Data')
legend('Transmitted Data', 'Received Data');
hold off

figure
hold on
stairs(X_hat(1:64), 'LineWidth', 1,'Color', 'blue')
stairs(tx(1:64), 'LineWidth', 1,'Color', 'red')
ylim([-1.35 1.35])
xlabel('Frequency Channels')
ylabel('Data')
legend('Received Estimate', 'Transmitted Data');
hold off