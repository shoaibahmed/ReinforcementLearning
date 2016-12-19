% Create a maze
maze = [
            true, true, true, false
            true, false, true, false
            true, true, true, true
       ];
   
terminatingState = [
            false, false, false, true
            false, false, false, true
            false, false, false, false
       ];
    
actions = [
               0, 1 % Right
               0, -1 % Left
               -1, 0 % Up
               1, 0 % Down
          ]; 

discountFactor = 0.9;
probabilityCorrectAction = 0.8;
probabilityWrongAction = 0.1; % 2 possible incorrect actions (right angle)
probabilityForMoveInEachDirection = 1 / size(actions, 1); % 4 possible directions to move in
rewardPerTimeStep = -0.04;
tolerance = 1e-5;
unicodeSymbolsForActions = {0, 8594, 8592, 8593, 8595}; % Unicode values for symbols to be used in visualization
startState = [size(maze, 1), 1];    % For episode sampling
       
% Define the value function
v = [
        0, 0, 0, 1
        0, 0, 0, -1
        0, 0, 0, 0
    ];

initialV = v;
previousV = zeros(size(v));