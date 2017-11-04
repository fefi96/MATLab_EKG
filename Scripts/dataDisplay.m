classdef dataDisplay < handle
    
    properties(GetAccess = 'public', SetAccess = 'private')
        dataPanel;
        buttonPanel;
        startButton;
        stopButton;
        diagramm;
        textHR;
    end
    
    properties(GetAccess = 'private', Constant)
        buttonWidthRatio = 0.4;
        buttonSpace = 20;
        diagrammWidthRatio = 0.9;
        diagrammHeightRatio = 0.7;
        
        dataPanelHeightFactor = 0.8;
        buttonPanelHeightFactor = 0.2;
        
        panelSidePadding = 10;
        panelTopDownPadding = 10;
        panelGap = 10;
    end
    
    methods(Access = 'public')
        function obj = dataDisplay(runner)
            %f = figure('Name', 'EKG', 'Color', 'white', 'ResizeFcn', {@(src, event)resizeCallback(obj, src, event)}, 'CloseRequestFcn', {@(src, event)closeCallback(obj, src, event, runner)});
            f = figure('Name', 'EKG', 'Color', 'white', 'ResizeFcn', {@(src, event)resizeCallback(obj, src, event)});
            
            obj.dataPanel = uipanel('Parent', f, 'Title', 'Data Panel', 'FontSize', 10, 'Units', 'Pixels');
            obj.buttonPanel = uipanel('Parent', f, 'Title', 'Button Panel', 'FontSize', 10, 'Units', 'Pixels');
            
            obj.startButton = uicontrol(obj.buttonPanel, 'Style', 'pushbutton', 'String', 'Start', 'Callback',{@(src, event)startCallback(obj, src, event, runner)});
            %obj.stopButton = uicontrol(obj.buttonPanel, 'Style', 'togglebutton', 'String', 'Stop', 'Callback', {@(src, event)stopCallback(obj, src, event, runner)});
            obj.stopButton = uicontrol(obj.buttonPanel, 'Style', 'togglebutton', 'String', 'Stop');
            obj.textHR = uicontrol(obj.dataPanel, 'Style', 'text');
            obj.diagramm = axes(obj.dataPanel, 'Box', 'on', 'xtick', [], 'ytick', []);
            
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
            height = figurePosition(4);
            buttonWidth = width * obj.buttonWidthRatio;
            %diagrammWidth = width * obj.diagrammWidthRatio;
            %diagrammHeight = height * obj.diagrammHeightRatio;
            
            dataToButtonPanelRatio = obj.dataPanelHeightFactor / obj.buttonPanelHeightFactor;
            
            set(obj.dataPanel, 'Position', [obj.panelSidePadding (1 - obj.panelTopDownPadding - obj.dataPanelHeight) 0.9 obj.dataPanelHeight]);
            set(obj.buttonPanel, 'Position', [obj.panelSidePadding obj.panelTopDownPadding 0.9 obj.buttonPanelHeight]);
            
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