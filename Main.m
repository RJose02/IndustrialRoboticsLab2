function testTechmannGUI()
 
    % Create TECHMANN object in its dedicated figure
    techmannRobot = TECHMANN();  % Plot environment and robot in fEnv figure

    % Create a separate figure for the GUI with control buttons
    fGUI = figure('Name', 'TECHMANN Control Panel', 'Position', [950, 100, 300, 300]);

    % Start Trajectory Button
    uicontrol(fGUI, 'Style', 'pushbutton', 'String', 'Pour My Smoothie', ...
              'FontSize', 14, 'Position', [50, 200, 200, 50], ...
              'Callback', @(src, event) techmannRobot.StartAutomaticRotation());

    % E-Stop Button
    uicontrol(fGUI, 'Style', 'pushbutton', 'String', 'E-Stop', ...
              'FontSize', 14, 'BackgroundColor', 'red', 'Position', [50, 100, 200, 50], ...
              'Callback', @(src, event) techmannRobot.StopRotation());
end


