function time_signal = freq_to_time(freq_signal)
%{
    Converts from the frequency domain to the time domain.
    
    Params: 
        freq_signal: frequency domain signal

    Returns:
        time_signal: time domain signal
%}
    time_signal = ifft(freq_signal);
end