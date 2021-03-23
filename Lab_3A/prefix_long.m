function data = prefix_long(signal, block_len, prefix_len, block_number)
    data = []; % running into undefined variable error
    for i = 1 : block_len : ((block_number * block_len) - (block_len - 1))
        ending = i+(block_len - 1);
        portion = signal(i:ending);
        prefixed = add_cyclic_prefix(portion, prefix_len);
        data = [data prefixed];
    end
end