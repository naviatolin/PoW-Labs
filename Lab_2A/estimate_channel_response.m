function H = estimate_channel_response(x1, x2, y1, y2, pulseWidth)
% Note: We are assuming noise is negligible.

% transmitter 1 transmits
starting_tx1 = 5001;
message_length = pulseWidth * 128;
ending_tx1 = starting_tx1 + message_length - 1;

x1_1 = x1(starting_tx1 : ending_tx1);
y1_1 = y1(starting_tx1 : ending_tx1);
y2_1 = y2(starting_tx1 : ending_tx1);

% transmitter 2 transmits
starting_tx2 = starting_tx1 + 5000 + message_length;
ending_tx2 = starting_tx2 + message_length - 1;

x2_2 = x2(starting_tx2 : ending_tx2);
y1_2 = y1(starting_tx2 : ending_tx2);
y2_2 = y2(starting_tx2 : ending_tx2);

% calculating the channel response
% when y1 is listening to x1 speak
h11 = mean(y1_1 ./ x1_1);
% when y2 is listening to x1 speak
h21 = mean(y2_1 ./ x1_1);

% when y1 is listening to x2 speak
h12 = mean(y1_2 ./ x2_2);
% when y2 is listening to x2 speak
h22 = mean(y2_2 ./ x2_2);

H = [h11 h12; h21 h22];
end