function output = add_cyclic_prefix(signal, prefix_length)
    delta = prefix_length + 1;
    cyclic_prefix = signal(end - delta: end);
    output = [cyclic_prefix signal];
end
