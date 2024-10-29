classdef Main
    properties
        env;   % Environment object
        UR3e;   % UR3 robot object
    end
    
    methods
        % Constructor
        function obj = Main()
            % Initialize the environment with safety equipment
            obj.env = Environment();  % Correct constructor call with parentheses
            
            % Load the UR3 robot from the provided UR3.m file
            obj.UR3e = UR3e();  % Assuming UR3.m defines the UR3 model
            
            % Shift the base of the UR3 to sit on top of the table (move entire robot)
            %obj.UR3e.model.base = transl(1, 0, 1.2);  % Shift the entire UR3 up by 1.0 units along z-axis.
            
            % Ensure the UR3 is plotted in the same figure as the environment
            figure(obj.env.fig);  % Set the current figure to the environment's figure
            
            % Re-plot the entire UR3 in the environment's workspace with the new base
            obj.UR3e.model.plot([0 0 0 0 0 0], 'workspace', [-7 7 -7 7 1 5]);  % Extend workspace boundaries
        end
    end
end
