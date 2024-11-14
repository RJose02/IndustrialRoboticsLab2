classdef TECHMANN < handle
    properties(Access = public)
        model           % SerialLink object for the TECHMANN robot
        plyFileNameStem = 'TM5-900Link';  % Default file name stem for TECHMANN PLY files
        homeQ           % Home joint configuration
        linkGraphics    % Stores graphic objects for each link
        linkVertices    % Stores original vertices for each link
        baseTransform   % Base transformation matrix for TECHMANN
        ur3eRobot       % UR3e robot object
        isMoving = false % Flag to control the trajectory execution
    end
    
    methods (Access = public)
        function self = TECHMANN(baseTr)
            % Constructor to create the TECHMANN model and set home configuration
            self.CreateModel();
            obj.env = Environment(); % Initialize the environment

            % Set the base transformation for TECHMANN
            if nargin < 1
                self.baseTransform = transl(-1.9, 0.9, 1.2);  % Default translation (adjust as needed)
            else
                self.baseTransform = baseTr;
            end
            
            % Initialize the UR3e robot with its own base transformation
            ur3eBaseTransform = transl(1.0, 0.75, 1.2); % Position UR3e robot 
            self.ur3eRobot = UR3e(ur3eBaseTransform);
            
            % Set environment properties (axis limits, lighting, etc.)
            axis([-5, 8, -4, 4, -1, 4]);
            daspect([1 1 1]);
            camlight('headlight');
            view(3);
            lighting gouraud;
            
            % Set default home configuration and plot the TECHMANN robot
            self.homeQ = [0 0 0 0 0 0 0];
            self.PlotAndColourRobot(self.homeQ);
        end

        function CreateModel(self)
            % Define DH parameters for the TECHMANN robot (TM5-900)
            link(1) = Link('d', 0, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360, 360])); 
            link(2) = Link('d', 0.28, 'a', 0, 'alpha', pi/2, 'qlim', deg2rad([-360, 360]));
            link(3) = Link('d', 0.30, 'a', 0, 'alpha', -pi/2, 'qlim', deg2rad([-360, 360]));
            link(4) = Link('d', 1.6, 'a', 0.26, 'alpha', 0, 'qlim', deg2rad([-360, 360])); 
            link(5) = Link('d', 0.106, 'a', 0, 'alpha', pi/2, 'qlim', deg2rad([-360, 360])); 
            link(6) = Link('d', 0.18, 'a', 0.19, 'alpha', 0, 'qlim', deg2rad([-360, 360])); 
            link(7) = Link('d', 0.09, 'a', 0.02, 'alpha', pi, 'qlim', deg2rad([-360, 360]));
            self.model = SerialLink(link, 'name', 'TM5-900');
        end
        
        function PlotAndColourRobot(self, q)
            % Plotting code for the TECHMANN robot
            % Define base path to PLY files
            basePath = 'C:\Users\natan\Downloads\rvctools\robot\UTS\RobotModels\@TM5-900\';
            scaleFactor = 0.02;
            numLinks = self.model.n;

            if isempty(self.linkGraphics) || ~all(isvalid(self.linkGraphics))
                self.linkGraphics = gobjects(1, numLinks);
                self.linkVertices = cell(1, numLinks);
                cumulativeTransform = self.baseTransform;

                for linkIndex = 1:numLinks
                    try
                        plyFile = [basePath, self.plyFileNameStem, num2str(linkIndex - 1), '.ply'];
                        [faceData, vertexData, ~] = plyread(plyFile, 'tri');
                        vertexData = vertexData * scaleFactor;

                        self.linkVertices{linkIndex} = vertexData;
                        A = self.model.A(linkIndex, q).T;
                        cumulativeTransform = cumulativeTransform * A;
                        verticesTransformed = (cumulativeTransform * [vertexData, ones(size(vertexData, 1), 1)]')';
                        verticesTransformed = verticesTransformed(:, 1:3);

                        self.linkGraphics(linkIndex) = trisurf(faceData, ...
                            verticesTransformed(:, 1), verticesTransformed(:, 2), verticesTransformed(:, 3), ...
                            'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none');
                    catch ME
                        disp(['Error loading PLY file for link ', num2str(linkIndex)]);
                        disp(ME.message);
                    end
                end
            else
                cumulativeTransform = self.baseTransform;
                for linkIndex = 1:numLinks
                    A = self.model.A(linkIndex, q).T;
                    cumulativeTransform = cumulativeTransform * A;

                    originalVertices = self.linkVertices{linkIndex};
                    verticesTransformed = (cumulativeTransform * [originalVertices, ones(size(originalVertices, 1), 1)]')';
                    verticesTransformed = verticesTransformed(:, 1:3);
                    set(self.linkGraphics(linkIndex), 'Vertices', verticesTransformed);
                end
                drawnow;
            end
        end

        function StartAutomaticRotation(self)
            if ~self.isMoving
                self.isMoving = true;
                self.RotateJointsSimultaneously([3, 5, 1], [-pi/6, 0, pi/2], [pi/3, -pi/2, pi/2], 0.5);
                self.isMoving = false;  % Reset after trajectory completes
            end
        end

        function StopRotation(self)
            self.isMoving = false;
        end

        function RotateJointsSimultaneously(self, jointIndices, startAngles, endAngles, duration)
            numSteps = 10;
            timeStep = duration / numSteps / 4;
            trajectories = zeros(numSteps, length(jointIndices));
            for j = 1:length(jointIndices)
                trajectories(:, j) = linspace(startAngles(j), endAngles(j), numSteps);
            end
            for i = 1:numSteps
                if ~self.isMoving
                    break;
                end
                currentQ = self.homeQ;
                for j = 1:length(jointIndices)
                    currentQ(jointIndices(j)) = trajectories(i, j);
                end
                self.PlotAndColourRobot(currentQ);
                if mod(i, 5) == 0 || i == numSteps
                    drawnow;
                end
                pause(timeStep);
            end
        end
    end
end
