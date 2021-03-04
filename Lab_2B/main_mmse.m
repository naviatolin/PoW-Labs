%% Parameters
clear all;

pulse_width = 1;

data1 = 'But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you yy';
data2 = 'account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human hapyy';
data3 = 'rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasyy';
data4 = 'encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain painyy';

train_data = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. C';

data_binary = (reshape(dec2bin(train_data, 8).'-'0',1,[])') .* 2  - 1;
data_empty = zeros(strlength(train_data) * 8, 1);

%% Generate Data

empties = repelem(data_empty, pulse_width);
samples = repelem(data_binary, pulse_width);

y_empty = real(MIMOChannel4x4([empties, empties, empties, empties]));

y1 = real(MIMOChannel4x4([samples, empties, empties, empties])); 
h1 = estimate_channel_response(samples', y1);

y2 = real(MIMOChannel4x4([empties, samples, empties, empties]));
h2 = estimate_channel_response(samples', y2);

y3 = real(MIMOChannel4x4([empties, empties, samples, empties]));
h3 = estimate_channel_response(samples', y3);

y4 = real(MIMOChannel4x4([empties, empties, empties, samples]));
h4 = estimate_channel_response(samples', y4);

H = [h1 h2 h3 h4];

%%
x_data1 = repelem(string_to_binvec(data1), pulse_width)';
x_data2 = repelem(string_to_binvec(data2), pulse_width)';
x_data3 = repelem(string_to_binvec(data3), pulse_width)';
x_data4 = repelem(string_to_binvec(data4), pulse_width)';
data_full = [ 
    x_data1
    x_data2
    x_data3
    x_data4
]';


y = real(MIMOChannel4x4(data_full));

%% 

lambda = var(y_empty(1,:));
ident = lambda*eye(4,4);
w = H' * inv( ( H * H' +  ident ));

%%
x_hat_raw = w * y
x_hat = sign(round(x_hat));

%%
% x1 = x_data1(pulse_width/2:pulse_width:end);
% x2 = x_data1(20:pulse_width:end);
% x3 = x_data1(20:pulse_width:end);
% x4 = x_data1(20:pulse_width:end);

% x_hat1 = x_hat(1, pulsewidth/2:pulse_width:end);
% x_hat2 = x_hat(2, 20:pulse_width:end);
% x_hat3 = x_hat(3, 20:pulse_width:end);
% x_hat4 = x_hat(4, 20:pulse_width:end);

%%
error1 = calculate_error(x_hat(1,:), x_data1);
% error2 = calculate_error(x_hat2, x2);
% error3 = calculate_error(x_hat3, x3);
% error4 = calculate_error(x_hat4, x4);