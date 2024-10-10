classdef RobotEnvironment
    properties
        Figure
        AxisLimits
        Objects  % A struct to hold handles to objects in the environment
        Bricks  % A cell array to hold handles to bricks
    end
    
    methods
        function self = RobotEnvironment()
            % Constructor: Initializes the environment and sets up the objects
            self.Figure = figure; %o pening figure window for Environment
            hold on; % ensuring that multiple objects can be plotted on the same figure
            
            % Set axis limits based on your script
            self.AxisLimits = [-6 4 -4 3 -1 3];  % Setting the axis limits for the figure
            axis(self.AxisLimits);
            xlabel('X');% Labelling
            ylabel('Y');% Labelling
            zlabel('Z');% Labelling
            view(3); %3d view
            grid on; %enabling grid lines in figure
            
            % Initialize the Objects struct to hold handles for placed objects
            self.Objects = struct(); % Initializing the objects Struct
            self.Bricks = cell(9, 1);  % Initializing a cell array to store 9 bricks
            
            % Place the objects in the environment
            self.PlaceEnvironmentObjects(); %Initializing function used to place objects (fence, table, etc.)
            
            % Define and place bricks
            self.PlaceBricks(); % Initializing function used to place bricks in Environment
        end
        
        function PlaceEnvironmentObjects(self)
            % Method to place environment objects (fence, table, etc.)
            
            
            
            % Person
           
        
        function PlaceBricks(self)
            % Method to place bricks at their initial positions
            
            % Define the initial positions of the bricks
            initialPositions = [0.9, -0.5, 0.5;
                                0.82, -0.5, 0.5;
                                0.72, -0.5, 0.5;
                                0.8, -0.5, 0.5;
                                0.9, -0.6, 0.5;
                                0.8, -0.6, 0.5;
                                0.7, -0.6, 0.5;
                                0.6, -0.6, 0.5;
                                0.5, -0.6, 0.5];

            % Create and place the bricks at their initial positions
            for i = 1:9
                self.Bricks{i} = self.PlaceObject('HalfSizedRedGreenBrick.ply', transl(initialPositions(i, :)));
            end
        end
        
        function mesh_h = PlaceObject(self, objectName, T) % Helper method to place an object into the environment
            % objectName: The name of the .ply file
            % T: Optional transformation matrix
            
            [faceData, vertexData, plyData] = plyread(objectName, 'tri');
            mesh_h = trisurf(faceData, vertexData(:, 1), vertexData(:, 2), vertexData(:, 3), ...
                'FaceVertexCData', [plyData.vertex.red, plyData.vertex.green, plyData.vertex.blue] / 255, ...
                'EdgeColor', 'none', 'EdgeLighting', 'flat');
            drawnow;
            
            % If transformation matrix is provided, apply it
            if nargin > 2
                vertices = get(mesh_h, 'Vertices');
                transformedVertices = [vertices, ones(size(vertices, 1), 1)] * T';
                set(mesh_h, 'Vertices', transformedVertices(:, 1:3));
            end
        end
    end
end
