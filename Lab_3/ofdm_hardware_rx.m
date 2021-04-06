%% Clear all
clear all;
close all;

%% Opening the sent and received files from the USRP.
load('tx_hardware.mat');

rx_f = fopen('rx_hardware.dat', 'r');
rx_unprocessed = fread(rx_f,'float32').';
fclose(rx_f);


%% Accounting for the delay.
%{
    This delay will remove any unnecessary bits before the start of the
    signal. The final length may not be the same length as what was
    originally sent because the receiver doesn't stop immediately after the
    signal stops.
%}
delay = find_delay(rx_unprocessed, finder_sequence) + length(finder_sequence); % should be 69
rx_delay = rx_unprocessed(delay:delay + length(tx_preambled));

%% Adjusting for the fdelta.
%{
    The second half of the Schmidl Cox algorithm is implemented here. The
    frequency shift can be accounted for here by finding the different
    between the sent prefix and the received prefix.
%}
% Seperating the first and second blocks out.
preamble_len = block_preamble * block_len; % 1x192
actual_signal_start = preamble_len + 1; % should be 193

% Seperating the preamble from the actual data.
rx_preamble_only = rx_delay(1:preamble_len); % 1x192

signal_length = (block_len + prefix_len) * block_num
rx_without_preamble = rx_delay(actual_signal_start : end);

first_lts_start = block_len + 1; % should be 65
first_lts_end = (block_len * 2); % should be 128
second_lts_start = first_lts_end + 1; % should be 129
second_lts_end = (block_len * 3); % should be 192

first_lts = rx_preamble_only(first_lts_start : first_lts_end); % 1x64
second_lts = rx_preamble_only(second_lts_start : second_lts_end); % 1x64

% Calculating F_delta.
f_sum = 0;
divided = second_lts ./ first_lts; % 1x64
f_angle = angle(divided); % 1x64
f_sum = sum(f_angle);
f_delta = f_sum / block_len / block_len;

% Apply F_delta.
rx_freq_adjusted = [];
for i = 1:length(rx_without_preamble)
    adjusted = rx_without_preamble(i) * exp(-1 * 1j * f_delta * i);
    rx_freq_adjusted = [rx_freq_adjusted adjusted];
end
%% Removing the cyclic prefix and converting to the frequency domain.
%{
    For each block, the prefix is removed and the DFT is taken.
    The final length of the signal will be the total block number
    multiplied by 64. The final length will be 6400 as there are 100
    blocks.
%}
rx_cropped = crop_long(rx_freq_adjusted, block_len, prefix_len, block_num); 

%% Splitting the received signal into the channel estimation and signal portions.
rx_channel_blocks = rx_cropped(1:end_channel);
rx_signal_blocks = rx_cropped(end_channel+1:end);

%% Estimating the channel.
multiple_channel_estimations = rx_channel_blocks./tx_channel_blocks;
h_stacked = reshape(multiple_channel_estimations, [block_len, block_channel]).';
H = mean(h_stacked);

%% Estimating the data sent. 
estimated_signal = estimate_signal(H, rx_signal_blocks, block_signal); % should be 1x5376

%% Correcting for phase offset using the pilot tones.
rx_phase_corrected = [];
for i = 1 : block_len : ((block_signal * block_len) - (block_len - 1))
    ending = i + (block_len - 1);
    portion = estimated_signal(i:ending); % should be 1x64
    fft_shifted = fftshift(portion);
    
    % Pulling out the pilot tones and piecing together data components.
    portion_no_guard = fft_shifted(7:end-5); % should be 1x53
    sec_1 = portion_no_guard(1); % should be 1x1
    pilot_1 = portion_no_guard(2);
    sec_2 = portion_no_guard(3:21); % should be 1x19
    pilot_2 = portion_no_guard(22);
    sec_3 = portion_no_guard(23:26);% should be 1x4
    sec_4 = portion_no_guard(28); % should be 1x1
    pilot_3 = portion_no_guard(29);
    sec_5 = portion_no_guard(30:48); % should be 1x19
    pilot_4 = portion_no_guard(49);
    sec_6 = portion_no_guard(50:end); % should be 1x4
    
    this_block = [sec_1 sec_2 sec_3 sec_4 sec_5 sec_6]; % should be 1x48

    % Calculating the phase offset.
    theta1 = angle(pilot_1/pilot_tone);
    theta2 = angle(pilot_2/pilot_tone);
    theta3 = angle(pilot_3/pilot_tone);
    theta4 = angle(pilot_4/pilot_tone);
    
    theta = (theta1 + theta2 + theta3 + theta4)/4;
    
    % Adjusting with ThetaK.
    y = this_block * exp(-1 * 1j * theta);
    
    rx_phase_corrected = [rx_phase_corrected y]; % should be 4032
end

%% Calculating the error.
%{
    Unnecessary complex components are removed. The sign is taken to allow
    only -1 and 1 values. This is in order to estimate the error correctly.
%}
X_hat = sign(real(rx_phase_corrected));

error = compute_error(X_hat, tx_gen_signal_blocks)

%% Figures created.
% Constellation plot of the data after receiving it.
figure
hold on
plot(rx_without_preamble, '.');
plot(estimated_signal, '.');
legend('received', 'estimated');

% Example block from the signal. 
figure
hold on
stairs(tx_signal_blocks(1:64), 'LineWidth', 1, 'Color', 'red')
stairs(estimated_signal(1:64), 'LineWidth', 1, 'Color', 'blue')
% ylim([-1.35 1.35])
xlabel('Frequency Channels')
ylabel('Data')
legend('Transmitted Data', 'Received Data');
hold off

%% Check if we are getting data.
figure
% stem(rx_unprocessed);
% stem(rx_unprocessed(2472400:2472955));
stem(rx_phase_corrected);
