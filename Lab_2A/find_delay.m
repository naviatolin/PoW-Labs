function [delay, lags, cor] = find_delay(y, x)
    [cor, lags] = xcorr(y, x);
    [~,index]=min(cor);
    delay = lags(index);
end