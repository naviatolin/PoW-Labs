function [delay, lags, cor] = find_delay(y, x)
%{
    Finds the delay between two signals.
    
    Params:
        x: first signal
        y: second signal

    Returns:
        delay: delay between the two signals.
        lags: all of the lags tried
        cor: all of the correlation values
%}
    [cor, lags] = xcorr(y, x);
    [~,index]=max(cor);
    delay = lags(index);
end