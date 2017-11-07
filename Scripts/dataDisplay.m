classdef dataDisplay < handle
    
    properties(GetAccess = 'public', SetAccess = 'private')
        dataPanel;
        buttonPanel;
        startButton;
        stopButton;
        diagramm;
        textHR;
        dispHR;
    end
    
    properties(GetAccess = 'private', Constant)
        dataPanelHeightFactor = 0.85;
        buttonPanelHeightFactor = 0.15;
        panelSidePadding = 10;
        panelTopDownPadding = 10;
        panelGap = 10;
        
        buttonPadding = 10;
        buttonSpace = 20;
        buttonHeight = 20;
        
        dataPanelInnerPadding = 10;
        textHeight = 20;
        textWidth = 100;
        textFontSize = 12;
        textFontWeight = 'bold';
    end
    
    methods(Access = 'public')
        function obj = dataDisplay(runner)
            %f = figure('Name', 'EKG', 'Color', 'white', 'ResizeFcn', {@(src, event)resizeCallback(obj, src, event)}, 'CloseRequestFcn', {@(src, event)closeCallback(obj, src, event, runner)});
            f = figure('Name', 'EKG', 'Color', 'white');
            
            obj.dataPanel = uipanel('Parent', f, 'Title', 'Data Panel', 'FontSize', 10, 'Units', 'Pixels');
            obj.buttonPanel = uipanel('Parent', f, 'Title', 'Button Panel', 'FontSize', 10, 'Units', 'Pixels');
            
            obj.startButton = uicontrol(obj.buttonPanel, 'Style', 'pushbutton', 'String', 'Start', 'Callback',{@(src, event)startCallback(obj, src, event, runner)});
            %obj.stopButton = uicontrol(obj.buttonPanel, 'Style', 'togglebutton', 'String', 'Stop', 'Callback', {@(src, event)stopCallback(obj, src, event, runner)});
            obj.stopButton = uicontrol(obj.buttonPanel, 'Style', 'togglebutton', 'String', 'Stop');
            obj.textHR = uicontrol(obj.dataPanel, 'Style', 'text', 'String', 'HR:', 'FontSize', obj.textFontSize, 'FontWeight', obj.textFontWeight);
            obj.dispHR = uicontrol(obj.dataPanel, 'Style', 'text', 'FontSize', obj.textFontSize, 'FontWeight', obj.textFontWeight);
            obj.diagramm = axes(obj.dataPanel, 'Box', 'on', 'xtick', [], 'ytick', [], 'Units', 'Pixels');
            
            set(f, 'ResizeFcn', {@(src, event)resizeCallback(obj, src, event)});
            
            obj.placeComponents(f.Position);
        end
        
        function showData(obj, vData, vHighPeaks, vLowPeaks, vThreshold, sHR)
            cla(obj.diagramm);
            plot(obj.diagramm, vData);
            hold on;
            plot(obj.diagramm, vLowPeaks, 'rv');
            hold on;
            plot(obj.diagramm, vHighPeaks, 'g^');
            hold on;
            plot(obj.diagramm, vThreshold);
            set(obj.dispHR, 'String', sHR);
            set(obj.diagramm, 'xtick', [], 'ytick', []);
            drawnow;
        end
    end
    
    methods(Access = 'private')
        function placeComponents(obj, figurePosition)
            figureWidth = figurePosition(3);
            panelWidth = figureWidth - (2 * obj.panelSidePadding);
            figureHeight = figurePosition(4);
            panelHeight = figureHeight - (2 * obj.panelTopDownPadding) - obj.panelGap;
            dataPanelHeight = panelHeight * obj.dataPanelHeightFactor;
            
            set(obj.dataPanel, 'Position', [obj.panelSidePadding (figureHeight - obj.panelTopDownPadding - dataPanelHeight)...
                panelWidth dataPanelHeight]);
            set(obj.buttonPanel, 'Position', [obj.panelSidePadding obj.panelTopDownPadding...
                panelWidth (panelHeight * obj.buttonPanelHeightFactor)]);
            
            dataPanelWidth = obj.dataPanel.InnerPosition(3);
            dataPanelHeight = obj.dataPanel.InnerPosition(4);
            diagrammWidth = dataPanelWidth - (obj.dataPanelInnerPadding * 3) - obj.textWidth;
            diagrammHeight = dataPanelHeight - (obj.dataPanelInnerPadding * 2);
            textX = (obj.dataPanelInnerPadding * 2) + diagrammWidth;
            textY = dataPanelHeight / 2;
            
            set(obj.diagramm, 'Position', [obj.dataPanelInnerPadding obj.dataPanelInnerPadding diagrammWidth diagrammHeight]);
            set(obj.textHR, 'Position', [textX (textY + (obj.dataPanelInnerPadding / 2)) obj.textWidth obj.textHeight]);
            set(obj.dispHR, 'Position', [textX (textY - obj.textHeight - (obj.dataPanelInnerPadding / 2)) obj.textWidth obj.textHeight]);
            
            buttonWidth = (obj.buttonPanel.InnerPosition(3) - (2 * obj.buttonPadding) - obj.buttonSpace) / 2;
            buttonY = (obj.buttonPanel.InnerPosition(4) / 2) - (obj.buttonHeight / 2);
            
            set(obj.startButton, 'Position', [obj.buttonPadding buttonY buttonWidth obj.buttonHeight]);
            set(obj.stopButton, 'Position', [(obj.buttonPadding + buttonWidth + obj.buttonSpace) buttonY buttonWidth obj.buttonHeight]);
        end
    end
    
    %Callbacks
    methods(Access = 'private')
        function resizeCallback(obj, src, ~)
            obj.placeComponents(src.InnerPosition);
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