classdef dataDisplay < handle
    
    properties(GetAccess = 'public', SetAccess = 'private')
        startButton
        stopButton
        diagramm
    end
    
    properties(GetAccess = 'private', Constant)
        buttonWidthRatio = 0.4;
        buttonSpace = 20;
        diagrammWidthRatio = 0.9;
        diagrammHeightRatio = 0.7;
    end
    
    methods(Access = 'public')
        function obj = dataDisplay(runner)
            f = figure('Name', 'EKG', 'Color', 'white', 'ResizeFcn', {@(src, event)resizeCallback(obj, src, event)}, 'CloseRequestFcn', {@(src, event)closeCallback(obj, src, event, runner)});
            
            obj.startButton = uicontrol(f, 'Style', 'pushbutton', 'String', 'Start', 'Callback',{@(src, event)startCallback(obj, src, event, runner)});
            %obj.stopButton = uicontrol(f, 'Style', 'togglebutton', 'String', 'Stop', 'Callback', {@(src, event)stopCallback(obj, src, event, runner)});
            obj.stopButton = uicontrol(f, 'Style', 'togglebutton', 'String', 'Stop');
            obj.diagramm = axes(f, 'Box', 'on', 'xtick', [], 'ytick', []);
            
            obj.placeComponents(f.Position);
        end
        
        function showData(obj, vData, vPeaks, vThreshold)
            cla(obj.diagramm);
            plot(obj.diagramm, vData);
            hold on;
            plot(obj.diagramm, vPeaks, 'rs');
            hold on;
            plot(obj.diagramm, vThreshold);
            set(obj.diagramm, 'xtick', [], 'ytick', []);
            drawnow;
        end
    end
    
    methods(Access = 'private')
        function placeComponents(obj, figurePosition)
            width = figurePosition(3);
            %height = figurePosition(4);
            buttonWidth = width * obj.buttonWidthRatio;
            %diagrammWidth = width * obj.diagrammWidthRatio;
            %diagrammHeight = height * obj.diagrammHeightRatio;
            
            set(obj.startButton, 'Position', [((width / 2) - buttonWidth - (obj.buttonSpace / 2)) 20 buttonWidth 20]);
            set(obj.stopButton, 'Position', [((width / 2) + (obj.buttonSpace / 2)) 20 buttonWidth 20]);
            set(obj.diagramm, 'Position', [0.05 0.2 obj.diagrammWidthRatio obj.diagrammHeightRatio]);
        end
    end
    
    %Callbacks
    methods(Access = 'private')
        function resizeCallback(obj, src, ~)
            obj.placeComponents(src.Position);
        end
        
        function closeCallback(~, ~, ~, runner)
            runner.reset;
            delete(gcf);
        end
        
        function startCallback(~, ~, ~, runner)
            runner.start;
        end
        
        %function stopCallback(~, ~, ~, runner)
        %
        %end
    end
end