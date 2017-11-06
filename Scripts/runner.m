classdef runner < handle
    
    properties(GetAccess = 'private', Constant)
        nAudioSampleRate = 8000;
        nPageLenInSamples = 800;
        nPages = 5;
        nDecimationFactor = 32;
    end
    
    properties(GetAccess = 'private', SetAccess = 'private')
        iAudioHandler;
        iFilterBlackBox;
        iSignalHistory;
        iThreshTracker;
        iThreshGuard;
        iHRCalculator;
        iDataDisplay;
        
        iDisplayStopButton;
        
        vDataSegment;
        vFilteredDataSegment;
        vHighPeaks;
        vLowPeaks;
        nThreshold;
        vThreshold;
    end
    
    properties(GetAccess = 'public', SetAccess = 'private')
       %iDataRecorder; 
    end
    
    methods(Access = 'public')
        function obj = runner()
            %obj.iDataRecorder = dataRecorder;
            obj.reset;
            obj.iThreshTracker = threshTracker(obj.nPageLenInSamples);
            obj.iHRCalculator = heartRateCalculator((obj.nAudioSampleRate / obj.nDecimationFactor));
            obj.iThreshGuard = threshGuard(obj.nPageLenInSamples, obj.iHRCalculator);
            
            obj.iDataDisplay = dataDisplay(obj);
            obj.iDisplayStopButton = obj.iDataDisplay.stopButton;
        end
        
        function start(obj)
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
            
            %obj.iAudioHandler = audioHandler(obj.nAudioSampleRate, obj.nPageLenInSamples, obj.nPages);
            obj.iAudioHandler = testData(obj.nPageLenInSamples);
            obj.iSignalHistory = signalHistory((obj.nAudioSampleRate / obj.nDecimationFactor) * 5);
            
            obj.iThreshTracker = threshTracker(obj.iSignalHistory.nSize);
            obj.iFilterBlackBox = filterBlackBox(obj.nAudioSampleRate, obj.nDecimationFactor);
            
            obj.vDataSegment = zeros(1, obj.nPageLenInSamples);
            obj.vFilteredDataSegment = zeros(1, obj.nPageLenInSamples);
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
                
                [obj.nThreshold, obj.vThreshold] = obj.iThreshTracker.calculateThreshold(obj.iSignalHistory.vData);
                [obj.vHighPeaks, obj.vLowPeaks] = obj.iThreshGuard.detectPeaks(obj.vFilteredDataSegment, obj.nThreshold);
                
                % mit iDataDisplay Signal, Schwellenwert und Herzrate anzeigen
                %disp(obj.iHRCalculator.calculateHeartRate());
                %obj.iDataRecorder.store(obj.vFilteredDataSegment);    
                obj.iDataDisplay.showData(obj.iSignalHistory.vData, obj.vHighPeaks, obj.vLowPeaks, obj.vThreshold, 'Test');
            end
        end
    end
end