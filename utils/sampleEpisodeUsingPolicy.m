% The script assumes that the environment has been setted up
episode = {};
maxEpisodeLength = 100;

% Sample an episode from the environment
i = startState(1);
j = startState(2);

terminationStateReached = false;
while ~terminationStateReached
    % Only update values specified locations
    if maze(i, j)
        % Select the action from policy
        k = policy(i, j);

        % Random number of evaluating whether the correct action will be executed
        randomNumber = rand();

        % If the random number generated is greater than the probability of correct action
        if randomNumber > probabilityCorrectAction
            % Add incorrect action (stochastic environment)
            if k < 3
                incorrectActions = [3, 4];
            else
                incorrectActions = [1, 2];
            end

            if randomNumber <= (probabilityCorrectAction + probabilityWrongAction)
                k = incorrectActions(1);
            else
                k = incorrectActions(2);
            end
        end

        % Add reward for correct action
        action = actions(k, :);
        iNew = i + action(1);
        jNew = j + action(2);

        if ((iNew > size(maze, 1)) || (iNew < 1))
            iNew = i;
        elseif (jNew > size(maze, 2)) || (jNew < 1)
            jNew = j;
        end

        % Position will remain the same if hand is banged over the wall
        if ~maze(iNew, jNew)
            iNew = i;
            jNew = j;
        end

        % Add the current reward and state to the episode
        episode{end + 1} = {[i, j], rewardPerTimeStep + initialV(i, j)};

        % End episode if terminating state
        if terminatingState(i, j) || (length(episode) >= maxEpisodeLength)
            terminationStateReached = true;
            break;
        end

        % Update the current position
        i = iNew;
        j = jNew;
    end
end
