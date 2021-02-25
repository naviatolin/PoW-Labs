%% Load the received .dat files in for future processing.
clear all
ftx = fopen('tx_data_signal_only.dat');
tx = fread(ftx, 'float32');
fclose(ftx);

frx = fopen('rx.dat');
rx = fread(frx, 'float32');
fclose(frx);

%% Seperate out tx and rx into real and imaginary components for later use.
tx = tx(51:end)'
i_tx = tx(1:2:end)
q_tx = tx(2:2:end)
tx = i_tx + 1i*q_tx

i_rx = rx(1:2:end);
q_rx = rx(2:2:end);
rx = i_rx + 1i*q_rx;
%% Define known variables.
symbol_period = 50;
sync_length = 50;
data_length = 2500;
total_length = sync_length + data_length;

%% Plot received data for constellation diagram.
figure
plot(real(rx), imag(rx),'.');
title('Constellation Diagram of the Received Data');
xlabel('Real');
ylabel('Imaginary');
%% Fftshift the data.
rx = rx ./ rms(rx);
N = length(rx);
fft_data = fft(rx.^4);
shifted_data = fftshift(fft_data);
[maximum,index_max] = max(abs(shifted_data));

%% Take impulse and adjust based on 4f and 4theta.
% evenly spaced out from pi -pi accounting for odd/even N (credit: Mark and
% Anusha)
discretized_frequency_axis = (linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2));

freq = discretized_frequency_axis(index_max) / 4;
theta = (angle(shifted_data(index_max)) + pi) / 4;

complex_exponent = exp((freq.*linspace(0,N,N) + theta)*1i)';
adjusted_data = complex_exponent .* rx;

%% Plot adjusted data
figure
plot(real(adjusted_data), imag(adjusted_data),'.');
title('Constellation Diagram of the Phase and Frequency Corrected Data');
xlabel('Real');
ylabel('Imaginary');
%% Autocorrelate the Data With the Sync
sync = ones(sync_length,1)';
[cor,lags] = xcorr(sync,adjusted_data);    
[max_xcorr,delay_index] = max(cor);
delay_start = abs(lags(delay_index))
received = adjusted_data(delay_start : delay_start+symbol_period*total_length); 

%% Check received data
i_received = real(received);
q_received = imag(received);
received = i_received + 1i*q_received;

figure 
plot(real(received), imag(received),'.');
title('Constellation Diagram of the Final Received Data');
xlabel('Real');
ylabel('Imaginary');

%%
% ceil and floor data
i = ones(length(i_received),1);
q = ones(length(q_received),1);
for k = 1:length(i_received)
    if i_received(k) >= 0
        i(k) = 1;
    else
        i(k) = -1;
    end
end
for k = 1:length(q_received)
    if q_received(k) >= 0
        q(k) = 1;
    else
        q(k) = -1;
    end
end

%% Ceil and Floor Data
errori = mean(sum((i ~= i_tx))) / length(i);
errorq = mean(sum((q ~= q_tx))) / length(q);
%%
figure 
hold on
stem(i_tx(500:550))
stem(i(500:550))
xlabel('Sample Time')
ylabel('Signal')
title('Stem Plot of Transmitted and Received Signal')
legend('Transmitted','Received')
hold off