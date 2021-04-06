function data = gen_data(block_num, block_len)
%{
    Generates a signal from random 1's and -1's.
    
    Params: 
        block_num: number of blocks to generate
        block_len: length of each block

    Returns:
        data: a vector of random 1's and 0's
%}
    data_len = block_num * block_len;
    data = (round(rand(1,data_len)) * 2) - 1;
end