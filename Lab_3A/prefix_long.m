function data = prefix_long(signal, block_len, prefix_len, block_number)
    data = []; % running into undefined variable error
    for i = 1 : block_len : ((block_number * block_len) - (block_len - 1))
        ending = i + (block_len - 1);
        portion = signal(i:ending);
        time = freq_to_time(portion);
        prefixed = add_cyclic_prefix(time, prefix_len);
        data = [data prefixed];
    end
end