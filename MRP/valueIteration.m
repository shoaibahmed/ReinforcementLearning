% Include utils
addpath('../utils');

% Create a maze
maze = [
            true, true, true, false
            true, false, true, false
            true, true, true, true
       ];
    
actions = [
               0, 1 % Right
               0, -1 % Left
               1, 0 % Up
               -1, 0 % Down
          ]; 

discountFactor = 0.5;
probabilityForMoveInEachDirection = 1 / size(actions, 1); % 4 possible directions to move in
rewardPerTimeStep = -0.04;
tolerance = 1e-5;
       
% Define the value function
v = [
        0, 0, 0, 1
        0, 0, 0, -1
        0, 0, 0, 0
    ];
        
previousV = zeros(size(maze));
        
% Perform value iteration
converged = false;
iterations = 0;
while ~converged
    % Visualize the value function
    close all;
    plotValues(v, strcat(['Value Function (', num2str(iterations), ' iterations)']));
    w = waitforbuttonpress; % 0 for button click and 1 for key press
    if w == 1
        break;
    end
    
    % Check if the algorithm converged
    delta = abs(previousV - v);
    if sum(delta(:)) < tolerance
        converged = true;
        break;
    end
    
    % Use previous v for calculation
    previousV = v;
    
    % Update the utlities
    % Iterate over the complete maze
    for i = 1 : size(maze, 1)
        for j = 1 : size(maze, 2)
            % Only update values specified locations
            if maze(i, j)
                % Iterate over all the actions
                reward = 0;
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

                    reward = reward + previousV(iNew, jNew) * probabilityForMoveInEachDirection;
                end

                % Update the utility
                v(i, j) = rewardPerTimeStep + discountFactor * reward;
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