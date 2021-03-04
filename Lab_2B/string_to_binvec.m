function OUT = string_to_binvec(S)
    OUT = (reshape(dec2bin(S, 8).'-'0',1,[])') .* 2  - 1;
end