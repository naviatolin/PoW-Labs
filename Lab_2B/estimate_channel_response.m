function H = estimate_channel_response(samples, response)
% samples: n x 1
% response: n x 4


% Just one column of H
% Make sure to run this fn for each training vector to assemble a full 4x4
H = [
 mean(response(1,:) ./ samples)  % h11 
 mean(response(2,:) ./ samples)  % h21 
 mean(response(3,:) ./ samples)  % h31 
 mean(response(4,:) ./ samples)  % h41 
];

end