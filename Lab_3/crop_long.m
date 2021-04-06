function data = crop_long(signal, block_len, prefix_len, block_number)
%{
    Crops the prefixes off of multiple blocks of data and converts it to
    the frequency domain.

    Params:
        signal: the signal that needs to be cropped
        block_len: length of one block
        prefix_len: length of the prefix
        block_number: number of blocks in this signal

    Returns:
        data: signal without cyclic prefixes in the frequency domain
%}
    data = [];
    chunk_len = block_len + prefix_len;
    for i = 1 : chunk_len : ((block_number * chunk_len) - (chunk_len - 1))
        ending = i+((block_len + prefix_len) - 1);
        portion = signal(i:ending);
        cropped = crop_signal(portion, prefix_len);
        time = time_to_freq(cropped);
        data = [data time];
    end
end