%% Clear
clear all
close all

%% OFDM Process

% Defining all constants.
block_len = 64; % number of channels in a block
prefix_len = 16; % length of the cyclic prefix
block_channel = 16; % number of blocks used to estimate channel
block_signal = 84; % number of blocks of actual data to calculate error
block_num = block_channel + block_signal; % 16 + 84 = 100

%% Generating data to send.
%{
    This generates all data that will have the cyclic prefix added to it. 
    This includes the data used to estimate the channel and the actual data
    that will be sent.
%}
tx = gen_data(block_num, block_len);

%% Splitting the blocks into channel estimation and signal portions.
end_channel = block_channel*block_len; % index seperating the channel estimation blocks from the data blocks

tx_channel_blocks = tx(1:end_channel); % 16 * 64 = 1024
tx_signal_blocks = tx(end_channel + 1:end); % 84 * 64 = 5376

%% Adding the cyclic prefix to the signal and converting to the time domain.
%{
    For each block, the IDFT is taken and then the cyclic prefix is added.
    The cyclic prefix length is 16. So, the final block length will be
    80. Since 100 blocks are being sent, the final length will be 8000.
%}
tx_prefixed = prefix_long(tx, block_len, prefix_len, block_num);

%% Passing the signal through the channel.
rx_unprocessed = nonflat_channel(tx_prefixed);

%% Accounting for the delay.
%{
    This delay will remove any unnecessary bits before the start of the
    signal. The final length may not be the same length as what was
    originally sent because the receiver doesn't stop immediately after the
    signal stops.
%}
delay = find_delay(rx_unprocessed, tx_prefixed); % should be 9
rx_delay = rx_unprocessed(delay:end);

%% Removing the cyclic prefix and converting to the frequency domain.
%{
    For each block, the prefix is removed and the DFT is taken.
    The final length of the signal will be the total block number
    multiplied by 64. The final length will be 6400 as there are 100
    blocks.
%}
rx_cropped = crop_long(rx_delay, block_len, prefix_len, block_num); 

%% Splitting the received signal into the channel estimation and signal portions.
rx_channel_blocks = rx_cropped(1:end_channel);
rx_signal_blocks = rx_cropped(end_channel+1:end);

%% Estimating the channel.
multiple_channel_estimations = rx_channel_blocks./tx_channel_blocks;
h_stacked = reshape(multiple_channel_estimations, [block_len, block_channel]).';
H = mean(h_stacked);

%% Estimating the data sent. 
estimated_signal = estimate_signal(H, rx_signal_blocks, block_signal);

%% Calculating the error.
%{
    Unnecessary complex components are removed. The sign is taken to allow
    only -1 and 1 values. This is in order to estimate the error correctly.
%}
X_hat = sign(real(estimated_signal));

error = compute_error(X_hat, tx_signal_blocks)

%% Figures created.
% Estimated channel.
figure 
stem(fftshift(ifft(H)))
xlabel('Time')
ylabel('Magnitude')

% actual channel
tmp = [0 -0.1 1 -0.1 0.05 -0.01 0 0 0 0 ];
tmp = resample(tmp, 10,9);
h = zeros(64,1);
h(8:8+length(tmp)-1) = tmp;
figure
stem(fftshift(h))
xlabel('Time')
ylabel('Magnitude')

% Constellation plot of the data after receiving it.
figure
hold on
plot(estimated_signal, '.');
xlabel('Real')
ylabel('Imaginary')

% Showing nonflat fading.
figure
hold on
stairs(tx_signal_blocks(1:64), 'LineWidth', 1, 'Color', 'red')
stem(rx_signal_blocks(1:64), 'LineWidth', 1, 'Color', 'blue')
ylim([-1.35 1.35])
xlabel('Frequency Channels')
ylabel('Data')
legend('Transmitted Data', 'Received Data');
hold off

% Example block from the signal. 
figure
hold on
stairs(tx_signal_blocks(1:64), 'LineWidth', 1, 'Color', 'red')
stairs(estimated_signal(1:64), 'LineWidth', 1, 'Color', 'blue')
ylim([-1.35 1.35])
xlabel('Frequency Channels')
ylabel('Data')
legend('Transmitted Data', 'Channel Effects Corrected Data');
hold off

