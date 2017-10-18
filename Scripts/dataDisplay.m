classdef dataDisplay < handle
    
    properties(GetAccess = 'private', SetAccess = 'private')
       startButton
       stopButton
       diagramm
    end
    
     properties(GetAccess = 'private', Constant)
       buttonRatio = 0.4;
       buttonSpace = 20;
     end
    
    methods(Access = 'public')
        function obj = dataDisplay(runner)
            f = figure('Name', 'EKG', 'Color', 'white', 'ResizeFcn', {@(src, event)resizeCallback(obj, src, event)});
            
            obj.startButton = uicontrol(f, 'Style', 'pushbutton', 'String', 'Start', 'Callback',{@(src, ~)startCallback(obj, src, runner)});
            obj.stopButton = uicontrol(f, 'Style', 'pushbutton', 'String', 'Stop', 'Callback', {@(src, ~)stopCallback(obj, src, runner)});
            %obj.diagramm = axes(f, 'Position', [], 'Box', 'on');
            
            obj.placeComponents(f.Position);
        end
    end
    
    methods(Access = 'private')
        function placeComponents(obj, figurePosition)
            width = figurePosition(3);
            buttonWidth = width * obj.buttonRatio;
            set(obj.startButton, 'Position', [((width / 2) - buttonWidth - (obj.buttonSpace / 2)) 20 buttonWidth 20]);
            set(obj.stopButton, 'Position', [((width / 2) + (obj.buttonSpace / 2)) 20 buttonWidth 20]);
            %diagramm set
        end
    end
    
    %Callbacks
    methods(Access = 'private')
        function resizeCallback(obj, src, ~)
            obj.placeComponents(src.Position);
        end
        
        function startCallback(obj, ~, runner)
            runner.running = true;
        end
        
        function stopCallback(obj, ~, runner)
            runner.running = false;
        end
    end
end