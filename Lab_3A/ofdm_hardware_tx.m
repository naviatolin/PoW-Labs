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
data_len = 48;

%% Generating the prefix
%{
    This generates the prefix that will be added to the cyclic prefixed
    data. There is also an alternating sequence appended to the beginning 6
    times in order to accurately find the beginning of the data. There were
    issues previously with just using the preamble to find the beginning of
    the data, so this alternating sequence helps this happen.
%}
block_preamble = 3; % number of blocks in preamble
lts = gen_data(1, block_len); % 1x64

% Constructing the preamble by copying the LTS 3 times.
preamble = [];
for i = 1:block_preamble
    preamble = [preamble lts];
end

% Append the alternating signal.
delay_find = [1 -1 1 -1 1 -1 1 -1 1 -1];
finder_sequence = [delay_find delay_find delay_find delay_find delay_find delay_find];
preamble = [finder_sequence preamble];
%% Generating data to send.
%{
    This generates all data. 
    This includes the data used to estimate the channel and the actual data
    that will be sent.
%}
tx = gen_data(block_num, data_len);

%% Adding pilot tones and guard bands to the data.
%{
    This creates pilot tones and adds guard bands to the data assuming that
    the 0 frequency component is in the middle. This data will be
    fftshifted before it is continued to be processed for sending.
%}
left_guard = [0, 0, 0, 0, 0, 0];
right_guard = [0, 0, 0, 0, 0];

tx_pilot_toned = [];
for i = 1 : data_len : ((block_num * data_len) - (data_len - 1))
    ending = i + (data_len - 1);
    portion = tx(i:ending); % should be 1x48
    
    % Defining the pilot_tone.
    pilot_tone = 1;
    
    % Portioning spaces between the pilot tones
    sec_1 = portion(1);
    sec_2 = portion(2:20);
    sec_3 = portion(21:24);
    sec_4 = portion(25);
    sec_5 = portion(26:44);
    sec_6 = portion(45:48);
    
    % Adding in pilot tones and guard bands.
    tx_piloted = [left_guard sec_1 pilot_tone sec_2 pilot_tone sec_3 0 sec_4 pilot_tone sec_5 pilot_tone sec_6 right_guard]; % should be 1x64
    tx_fftshift = fftshift(tx_piloted); % should be 1x64, indices 28 - 38 should be 0
    tx_pilot_toned = [tx_pilot_toned tx_fftshift]; % should be 1x6400
end
clear sec_1 sec_2 sec_3 sec_4 sec_5 sec_6

%% Splitting the blocks into channel estimation and signal portions.
end_channel = block_channel*block_len; % index seperating the channel estimation blocks from the data blocks

tx_channel_blocks = tx_pilot_toned(1:end_channel); % 16 * 64 = 1024
tx_signal_blocks = tx_pilot_toned(end_channel + 1:end); % 84 * 64 = 5376


end_gen_channel = block_channel*data_len;
tx_gen_channel_blocks = tx(1:end_gen_channel); % 16 * 48 = 768
tx_gen_signal_blocks = tx(end_gen_channel + 1:end); % 84 * 48 = 4032

%% Adding the cyclic prefix to the signal and converting to the time domain.
%{
    For each block, the IDFT is taken and then the cyclic prefix is added.
    The cyclic prefix length is 16. So, the final block length will be
    80. Since 100 blocks are being sent, the final length will be 8000.
%}
tx_prefixed = prefix_long(tx_pilot_toned, block_len, prefix_len, block_num);

%% Appending the preamble to the prefixed data.
tx_preambled = [preamble tx_prefixed];

%% Save the file to a .dat format for sending over USRP.
tx_f = fopen('tx_hardware.dat', 'w+');
fwrite(tx_f, tx_preambled, 'float32');
fclose(tx_f);

clear ans
save('tx_hardware')