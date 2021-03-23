function data = crop_long(signal, block_len, prefix_len, block_number)
    data = [];
    chunk_len = block_len + prefix_len;
    for i = 1 : chunk_len : ((block_number * chunk_len) - (chunk_len - 1))
        ending = i+((block_len + prefix_len) - 1);
        portion = signal(i:ending);
        cropped = crop_signal(portion, prefix_len, block_len);
        time = time_to_freq(cropped);
        data = [data time];
    end
end