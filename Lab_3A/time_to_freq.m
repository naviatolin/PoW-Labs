function freq_signal = time_to_freq(time_signal)
%{
    Converts from the time domain to the frequency domain.
    
    Params: 
        time_signal: time domain signal

    Returns:
        freq_signal: frequency domain signal
%}
    freq_signal = fft(time_signal);
end