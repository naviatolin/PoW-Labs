function cropped = crop_signal(data, prefix_length, block_len)
    starting = prefix_length + 1;
    cropped = data(starting:end);
end