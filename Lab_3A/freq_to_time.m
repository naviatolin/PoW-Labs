function time_signal = freq_to_time(freq_signal)
    time_signal = ifft(freq_signal);
end