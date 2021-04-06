function error = compute_error(data_hat, data)
%{
    Computes the error between estimated received data and 
 
    Params:
        data_hat: processed received data
        data: sent data

    Returns:
        error: error in decimal format
%}
    error_num = sum(data_hat ~= data);
    error = error_num/(length(data));
end