function Y = MIMOChannel4x4(X)
%   simulated flat-fading MIMO channel
%   X is an input matrix that is N x 4 long, where the columns are the
%   length N transmitted signals from four transmit antennas
%
%   Y is a N x 4 matrix whose columns are the N samples received at each of
%   the 4 received antennas


% each row is a sample
% each column is a transmitter


H = 1e-2*[0.1234+1.102j  1.114+0.102j 0.8712+1.0121j 0.701+0.635j; ];

H = 1e-7*[ -0.5403 + 2.0193i  -0.3531 - 0.8203i   0.3927 - 0.9271i   0.5318 + 0.3695i; 1.7175 - 1.7937i   1.6931 + 0.0179i  -0.8780 - 0.1699i  -0.7597 - 0.6186i; 0.8198 - 0.6595i   0.7111 + 0.6545i   0.1489 - 0.4717i   0.3480 + 0.8001i;    0.0555 + 0.7715i  -0.6328 + 1.2577i   1.5319 - 0.1142i  -0.6978 + 0.4267i];
N0 = 1e-12;


tmp = size(X);
if (tmp(2) == 4)
    X = transpose(X);
end

if (tmp(1) ~=4)
    if(tmp(2) ~= 4)
        disp('Error: X matrix has to have either 4 columns or rows');
        return;
    end
end

Y = H*X;
Y = Y + N0/sqrt(2)*randn(size(Y)) + N0/sqrt(2)*j*randn(size(Y));

end