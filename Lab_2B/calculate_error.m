function error = calculate_error(data_hat, data)
%     error_num = sum(abs(reshape(data' - data_hat, 1, [])))
    error_num = sum(sign(abs(data - data_hat)));
    error = error_num/(length(data));
end