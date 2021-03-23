function error = compute_error(data_hat, data)
    error_num = sum(sign(abs(data - data_hat)));
    error = error_num/(length(data));
end