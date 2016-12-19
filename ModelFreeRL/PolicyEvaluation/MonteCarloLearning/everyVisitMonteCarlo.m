% Include utils
addpath('../../../utils');

% Setup environment
setupEnvironment;

% Define random policy
policy = randi([1, size(actions, 1)], size(maze));
policy(~maze) = 0;
previousPolicy = zeros(size(maze));

% Keep count of the number of times a state is visited
visitCounts = zeros(size(v));

% Perform value iteration
converged = false;
iterations = 0;
while ~converged
    % Visualize the value function
    close all;
    plotValues(v, strcat(['Value Function (', num2str(iterations), ' iterations)']));
    
    % Check if the algorithm converged
    delta = abs(previousV - v);
    if sum(delta(:)) < tolerance
        converged = true;
        break;
    end

    % Stop the algorithm if user pressed a button
    w = waitforbuttonpress; % 0 for button click and 1 for key press
    if w == 1
        break;
    end
    
    % Use previous v for calculation (synchronous update)
    previousV = v;
    
    % Sample episode from the environment (Will populate episode cell)
    sampleEpisodeUsingPolicy;
    
    % Compute the total discounted reward for the episode
    totalDiscountedRewards = zeros(1, length(episode));
    for i = length(totalDiscountedRewards) : -1 : 1
        instance = episode{i};
        reward = instance{2};
        if i < length(totalDiscountedRewards)
            totalDiscountedRewards(i) = reward + discountFactor * totalDiscountedRewards(i + 1);
        else
            totalDiscountedRewards(i) = reward;
        end
    end
    
    % Update the state value function
    % Iterate over the complete episode
    for i = 1 : length(episode)
        instance = episode{i};
        state = instance{1};
        
        % Perform incremental monte-carlo update
        visitCounts(state(1), state(2)) = visitCounts(state(1), state(2)) + 1;
        v(state(1), state(2)) = v(state(1), state(2)) + (1 / visitCounts(state(1), state(2))) * (totalDiscountedRewards(i) - v(state(1), state(2)));
    end
        
    iterations = iterations + 1;
end

if converged
    fprintf('Every visit Monte-Carlo policy evaluation algorithm converged to the solution in %d iterations\n', iterations);
else
    fprintf('Process interrupted by user after %d iterations\n', iterations);
end