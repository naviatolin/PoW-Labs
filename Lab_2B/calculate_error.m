function error = calculate_error(data_hat, data)
    error = sum(abs(reshape(data' - data_hat, 1, [])))/(length(data));
end