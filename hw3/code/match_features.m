% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Please implement the "nearest neighbor distance ratio test", 
% Equation 4.18 in Section 4.1.3 of Szeliski. 
% For extra credit you can implement spatial verification of matches.

%
% Please assign a confidence, else the evaluation function will not work.
%

% This function does not need to be symmetric (e.g., it can produce
% different numbers of matches depending on the order of the arguments).

% Input:
% 'features1' and 'features2' are the n x feature dimensionality matrices.
%
% Output:
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index in features2. 
%
% 'confidences' is a k x 1 matrix with a real valued confidence for every match.

function [matches, confidences] = match_features(features1, features2)

THRESHOLD = 0.9;

[n1, f] = size(features1);
[n2, f] = size(features2);

dists = zeros(n1, n2);
for i = 1 : n1
    for j = 1 : n2
        dists(i, j) = norm(features1(i, :) - features2(j, :));
    end
end

[sorted_dists, idx] = sort(dists, 2);
NNdist = sorted_dists(:, 1:2);
ratios = NNdist(:, 1) ./ NNdist(:, 2);

confidences = 1 ./ ratios(ratios < THRESHOLD);
matches = zeros(size(confidences, 1), 2);
matches(:, 1) = find(ratios < THRESHOLD);
matches(:, 2) = idx(ratios < THRESHOLD);

% Remember that the NNDR test will return a number close to 1 for 
% feature points with similar distances.
% Think about how confidence relates to NNDR.
end