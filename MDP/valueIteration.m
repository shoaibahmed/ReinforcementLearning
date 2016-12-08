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
probabilityCorrectAction = 0.8;
probabilityWrongAction = 0.1; % 2 possible incorrect actions (right angle)
rewardPerTimeStep = -0.04;
tolerance = 1e-5;
       
% Define the utility function
utilities = [
                0, 0, 0, 1
                0, 0, 0, -1
                0, 0, 0, 0
            ];
        
previousUtilities = zeros(size(maze));
        
% Perform value iteration
converged = false;
iterations = 0;
while ~converged
    % Visualize the utilities
    close all;
    plotValues(utilities, strcat(['Value Function (', num2str(iterations), ' iterations)']));
    w = waitforbuttonpress; % 0 for button click and 1 for key press
    if w == 1
        break;
    end
    
    % Check if the algorithm converged
    delta = abs(previousUtilities - utilities);
    if sum(delta(:)) < tolerance
        converged = true;
        break;
    end
    
    % Use previous utilities for calculation
    previousUtilities = utilities;
    
    % Update the utlities
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

                    reward = previousUtilities(iNew, jNew) * probabilityCorrectAction;

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

                        reward = reward + previousUtilities(iNew, jNew) * probabilityWrongAction;
                    end

                    % Save reward in maxReward if best action
                    if reward > maxReward
                        maxReward = reward;
                    end
                end

                % Update the utility
                utilities(i, j) = rewardPerTimeStep + discountFactor * maxReward;
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