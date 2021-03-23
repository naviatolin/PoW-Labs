function output = add_cyclic_prefix(signal, prefix_length)
    delta = prefix_length - 1;
    starting = length(signal) - delta;
    cyclic_prefix = signal(starting : end);
    output = [cyclic_prefix signal];
end
