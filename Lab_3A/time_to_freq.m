function freq_signal = time_to_freq(time_signal)
    freq_signal = fft(time_signal);
end