function cropped = crop_signal(data, prefix_length)
%{
    Crops the prefix off of one block of data.

    Params:
        data: signal of block length 1

    Returns:
        cropped: signal without the cyclic prefix
%}
    starting = prefix_length + 1;
    cropped = data(starting:end);
end