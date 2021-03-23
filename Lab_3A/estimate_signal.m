function X_hat = estimate_signal(channel, signal, block_num)
    repeated_channel = repmat(channel, 1, block_num);
    X_hat = signal./repeated_channel;
end