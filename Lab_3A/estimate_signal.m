function X_hat = estimate_signal(channel, signal, block_num)
%{
    Estimates the signal given the channel response.

    Params:
        channel: matrix representing the channel response
        signal: received signal from the channel
        block_num: length of the signal in blocks

    Returns:
        X_hat: the estimated signal using the channel response
%}
    repeated_channel = repmat(channel, 1, block_num);
    X_hat = signal./repeated_channel;
end