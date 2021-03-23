function data = gen_data(block_num, block_len)
    data_len = block_num * block_len;
    data = (round(rand(1,data_len)) * 2) - 1;
end