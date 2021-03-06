function str = binvec_to_string(binary) 
    str = char(bin2dec(reshape(char(binary+'0'), 8,[]).'));
end