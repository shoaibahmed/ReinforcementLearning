% Include utils
addpath('../../../utils');

% Setup environment
setupEnvironment;
learningRate = 0.1; % Alpha
lambda = 0.9; % For eligiblity traces

% Define random policy
policy = randi([1, size(actions, 1)], size(maze));
policy(~maze) = 0;
previousPolicy = zeros(size(maze));

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
    episodeLength = length(episode);
    eligibilityTraces = zeros(size(v));
    
    % Update the state value function
    % Iterate over the complete episode
    for i = 1 : episodeLength
        instance = episode{i};
        state = instance{1};
        reward = instance{2};
                
        % Update eligibility traces
        for m = 1 : size(eligibilityTraces, 1)
            for n = 1 : size(eligibilityTraces, 2)
                recentlyVisited = 0;
                if (m == state(1) && n == state(2))
                    recentlyVisited = 1;
                end
                eligibilityTraces(m, n) = lambda * discountFactor * eligibilityTraces(m, n) + recentlyVisited;
            end
        end
        
        % Perform TD-Lambda update
        valueFunctionAtNextState = 0;
        if i < episodeLength
            instance = episode{i + 1};
            nextState = instance{1};
            valueFunctionAtNextState = v(nextState(1), nextState(2));
        end
        
        tdTarget = reward + discountFactor * valueFunctionAtNextState;
        tdError = tdTarget - v(state(1), state(2));
        v(state(1), state(2)) = v(state(1), state(2)) + learningRate * tdError * eligibilityTraces(state(1), state(2));
    end
        
    iterations = iterations + 1;
end

if converged
    fprintf('Temporal Difference (TD-0) policy evaluation algorithm converged to the solution in %d iterations\n', iterations);
else
    fprintf('Process interrupted by user after %d iterations\n', iterations);
end