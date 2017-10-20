classdef runner < handle
    
    properties(GetAccess = 'private', Constant)
        nAudioSampleRate = 8000;
        nPageLenInSamples = 4000;
        nPages = 5;
        nDecimationFactor = 32;
    end
    
    properties(GetAccess = 'private', SetAccess = 'private')
        iAudioHandler
        iFilterBlackBox
        iSignalHistory
        iThreshTracker
        iThreshGuard
        iHRCalculator
        iDataDisplay
        
        iDisplayStopButton
        
        vDataSegment
        vFilteredDataSegment
    end
    
    methods(Access = 'public')
        function obj = runner()
            
            obj.reset;
            %obj.iThreshTracker = threshTracker();
            %obj.iThreshGuard = threshGuard();
            %obj.iHRCalculator = heartRateCalculator();
            
            obj.iDataDisplay = dataDisplay(obj);
            obj.iDisplayStopButton = obj.iDataDisplay.stopButton;
        end
        
        function start(obj)
            %obj.bRunning = true;
            obj.iAudioHandler.start;
            obj.tick;
        end
        
        function stop(obj)
            obj.reset;
        end
        
        function reset(obj)
            
            if(playrec('isInitialised'))
                playrec('delPage');
                playrec('reset');
            end
            
            obj.iAudioHandler = audioHandler(obj.nAudioSampleRate, obj.nPageLenInSamples, obj.nPages);
            %obj.iAudioHandler = testData;
            obj.iSignalHistory = signalHistory(obj.nPageLenInSamples);
            obj.iFilterBlackBox = filterBlackBox(obj.nAudioSampleRate, obj.nDecimationFactor);
            
            obj.vDataSegment = zeros(1, length(obj.vDataSegment));
            obj.vFilteredDataSegment = zeros(1, length(obj.vFilteredDataSegment));
        end
    end
    
    methods(Access = 'private')
        
        function tick(obj)
            %while(obj.bRunning)
            while(true)
                % Wiederhole bis Abbruch
                if(get(obj.iDisplayStopButton, 'Value'))
                    set(obj.iDisplayStopButton, 'Value', 0)
                    obj.reset;
                    break;
                end
                
                obj.vDataSegment = obj.iAudioHandler.waitForData();
                
                obj.vFilteredDataSegment = obj.iFilterBlackBox.process(obj.vDataSegment);
                obj.iSignalHistory.store(obj.vFilteredDataSegment);
                obj.iDataDisplay.showData(obj.iSignalHistory.vData);
                
                % mit iThreshTracker Schwelle berechnen
                % mit iThreshGuard Schwelle �berwachen
                % mit iHRCalculator aktuelle Herzfrequenz berechnen
                % mit iDataDisplay Signal, Schwellenwert und Herzrate anzeigen
            end
        end
    end
end