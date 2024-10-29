classdef Environment
    properties
        table;          % Table object
        foodProcessor;  % Food processor object
        safetyEquipment; % Safety equipment objects
        fig;            % Figure for the environment
        trays;
        cups;
        fruits;

    end
    
    methods
        % Constructor
        function obj = Environment()
            % Initialize figure
            obj.fig = figure('Name', 'Smoothie Robot Environment');
            hold on;
            
            % Load the table and place it in the environment
            obj.table = PlaceObject('table1.ply', [0, 0, 0]);
            obj.table = PlaceObject('wholeTM5.ply', [-1.9, 0.9, 1.2]);
            % Load the food processor and place it in the environment
            obj.foodProcessor = PlaceObject('foodprocessor.ply', [-0.25, 0.5, 1.5]); % Position remains unchanged

            % Load the trays for the fruits and place it in the environment
            obj.trays.Tray1 = PlaceObject('Tray1.ply', [1.35, 1, 1.2])
            obj.trays.Tray2 = PlaceObject('Tray2.ply', [0.55, 1, 1.2])
            obj.trays.Tray3 = PlaceObject('Tray3.ply', [-0.25, 1, 1.2])

            % Load the trays for the fruits and place it in the environment
            obj.cups.Cup1 = PlaceObject('Cup1.ply', [-1.5, -0.9, 1.1])
            obj.cups.Cup2 = PlaceObject('Cup2.ply', [-0.8, -0.9, 1.1])
            obj.cups.Cup3 = PlaceObject('Cup3.ply', [-0.1, -0.9, 1.1])

            % Load the fruits and place it in the environment
            obj.fruits.orange1 = PlaceObject('orange1.ply', [1.45, 1.2, 1.2])
            obj.fruits.orange2 = PlaceObject('orange2.ply', [1.2, 1.4, 1.2])

            obj.fruits.peach1 = PlaceObject('peach1.ply', [0.35, 1.1, 1.2])
            obj.fruits.peach2 = PlaceObject('peach2.ply', [0.6, 1.25, 1.2])
            obj.fruits.peach3 = PlaceObject('peach3.ply', [0.4, 1.4, 1.2])

            obj.fruits.strawberry1 = PlaceObject('strawberry1.ply', [-0.2, 1.4, 1.2])
            obj.fruits.strawberry2 = PlaceObject('strawberry2.ply', [-0.4, 1.3, 1.2])
            obj.fruits.strawberry3 = PlaceObject('strawberry3.ply', [-0.2, 1.1, 1.2])
            obj.fruits.strawberry4 = PlaceObject('strawberry4.ply', [-0.5, 1.1, 1.2])
            obj.fruits.strawberry5 = PlaceObject('strawberry5.ply', [-0.5, 1.5, 1.2])


            % Load specific safety equipment
            obj.safetyEquipment.emergencyStop = PlaceObject('emergencyStopWallMounted.ply', [4.5, -2.3, 1.5]); % Position remains unchanged
            obj.safetyEquipment.fence = PlaceObject('fenceAssemblyGreenRectangle4x8x2.5m.ply', [1.5, 1.5, -2.4]); % Position remains unchanged
            obj.safetyEquipment.fireExtinguisher = PlaceObject('fireExtinguisher.ply', [6, -2.2, -1]); % Add position for the fire extinguisher
            obj.safetyEquipment.beacon = PlaceObject('sign.ply', [2, 3, 0]);
            
            % Set up the workspace boundaries and labels
            axis equal;
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
        end
    end
end
