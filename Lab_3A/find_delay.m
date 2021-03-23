function [delay, lags, cor] = find_delay(y, x)
    [cor, lags] = xcorr(y, x);
    [~,index]=max(cor);
    delay = lags(index);
end