% Include utils
addpath('../../../utils');

% Setup environment
setupEnvironment;
        
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
    
    % Update the state value function
    % Iterate over the complete maze
    for i = 1 : size(maze, 1)
        for j = 1 : size(maze, 2)
            % Only update values specified locations
            if maze(i, j)
                % Iterate over all the actions
                maxReward = -realmax;
                for k = 1 : size(actions, 1)
                    % Add reward for correct action
                    action = actions(k, :);
                    iNew = i + action(1);
                    jNew = j + action(2);

                    if (iNew > size(maze, 1)) || (iNew < 1)
                        iNew = i;
                    elseif (jNew > size(maze, 2)) || (jNew < 1)
                        jNew = j;
                    end

                    reward = previousV(iNew, jNew) * probabilityCorrectAction;

                    % Add reward for incorrect action (stochastic environment)
                    if k < 3
                        incorrectActions = [3, 4];
                    else
                        incorrectActions = [1, 2];
                    end

                    for z = incorrectActions
                        action = actions(z, :);
                        iNew = i + action(1);
                        jNew = j + action(2);

                        if (iNew > size(maze, 1)) || (iNew < 1)
                            iNew = i;
                        elseif (jNew > size(maze, 2)) || (jNew < 1)
                            jNew = j;
                        end

                        reward = reward + previousV(iNew, jNew) * probabilityWrongAction;
                    end

                    % Save reward in maxReward if best action
                    if reward > maxReward
                        maxReward = reward;
                    end
                end

                % Update v using Bellman optimality equation
                v(i, j) = rewardPerTimeStep + discountFactor * maxReward;
            end
        end
    end
    
    iterations = iterations + 1;
end

if converged
    fprintf('Value iteration algorithm converged to the solution in %d iterations\n', iterations);
else
    fprintf('Process interrupted by user after %d iterations\n', iterations);
end

% Develop the final policy according to the value function
policy = randi([1, size(actions, 1)], size(maze));
policy(~maze) = 0;

% Iterate over the complete maze
for i = 1 : size(maze, 1)
    for j = 1 : size(maze, 2)
        % Only update values specified locations
        if maze(i, j)
            % Iterate over all the actions
            maxReward = -realmax;
            bestAction = -1;
            for k = 1 : size(actions, 1)
                % Add reward for correct action
                action = actions(k, :);
                iNew = i + action(1);
                jNew = j + action(2);

                if (iNew > size(maze, 1)) || (iNew < 1)
                    iNew = i;
                elseif (jNew > size(maze, 2)) || (jNew < 1)
                    jNew = j;
                end

                % Don't update state for blocked cells (Win and Lose states are also blocked but don't have zero value)
                if maze(iNew, jNew) || (~maze(iNew, jNew) && (v(iNew, jNew) ~= 0))
                    reward = v(iNew, jNew);

                    % Save reward in maxReward if best action
                    if reward > maxReward
                        maxReward = reward;
                        bestAction = k;
                    end
                end
            end

            % Update the policy
            policy(i, j) = bestAction;
        end
    end
end

% Visualize the policy obtained by acting greedily with respect to the obtained value function
unicodeSymbolsForActions = {0, 8594, 8592, 8593, 8595}; % Unicode values for symbols to be used in visualization
plotValues(policy, 'Policy', unicodeSymbolsForActions);