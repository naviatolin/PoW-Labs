function output = add_cyclic_prefix(signal, prefix_length)
%{
    Adding the cyclic prefix to the beginning of one block.

    Params:
        signal: one block of signal
        prefix_length: length of the prefix to add

    Returns:
        output: one block of signal which has the cyclic prefix attached to
        it
%}
    delta = prefix_length - 1;
    starting = length(signal) - delta;
    cyclic_prefix = signal(starting : end);
    output = [cyclic_prefix signal];
end
