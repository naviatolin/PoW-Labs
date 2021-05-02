function data = prefix_long(signal, block_len, prefix_len, block_number)
%{
    Converts the data to the time domain and add the cyclic prefix.
    
    Params:
        signal: signal to convert and prefix
        block_len: length of one block
        prefix_len: length of the cyclic prefix
        block_number: total number of blocks of information

    Returns:
        data: time domain signal with cyclic prefixes
%}
    data = []; % running into undefined variable error
    for i = 1 : block_len : ((block_number * block_len) - (block_len - 1))
        ending = i + (block_len - 1);
        portion = signal(i:ending);
        time = freq_to_time(fftshift(portion));
        prefixed = add_cyclic_prefix(time, prefix_len);
        data = [data prefixed];
    end
end