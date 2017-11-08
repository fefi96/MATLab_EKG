classdef runner < handle
    
    properties(GetAccess = 'private', Constant)
        nAudioSampleRate = 8000;
        nPageLenInSamples = 800;
        nPages = 5;
        nDecimationFactor = 32;
        nSecondsToStore = 5;
    end
    
    properties(GetAccess = 'private', SetAccess = 'private')
        iAudioHandler;
        iFilterBlackBox;
        iSignalHistoryData;
        iSignalHistoryHighPeaks;
        iSignalHistoryLowPeaks;
        iThreshTracker;
        iThreshGuard;
        iHRCalculator;
        iDataDisplay;
        
        iDisplayStopButton;
        
        vDataSegment;
        vFilteredDataSegment;
        nThreshold;
        vThreshold;
        
        nStoreSize;
    end
    
    properties(GetAccess = 'public', SetAccess = 'private')
       %iDataRecorder; 
    end
    
    methods(Access = 'public')
        function obj = runner()
            %obj.iDataRecorder = dataRecorder;
            obj.nStoreSize = (obj.nAudioSampleRate / obj.nDecimationFactor) * obj.nSecondsToStore;
            obj.reset;
            obj.iHRCalculator = heartRateCalculator((obj.nAudioSampleRate / obj.nDecimationFactor));
            obj.iThreshGuard = threshGuard(obj.iHRCalculator);
            
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
            obj.iSignalHistoryData = signalHistory(obj.nStoreSize);
            obj.iSignalHistoryHighPeaks = signalHistory(obj.nStoreSize);
            obj.iSignalHistoryLowPeaks = signalHistory(obj.nStoreSize);

            obj.iThreshTracker = threshTracker(obj.iSignalHistoryData.nSize);
            obj.iFilterBlackBox = filterBlackBox(obj.nAudioSampleRate, obj.nDecimationFactor);
            
            obj.vDataSegment = zeros(1, obj.nPageLenInSamples);
            obj.vFilteredDataSegment = zeros(1, obj.nPageLenInSamples / obj.nDecimationFactor);
        end
    end
    
    methods(Access = 'private')
        
        function tick(obj)
            
            while(true)
                % Wiederhole bis Abbruch
                if(get(obj.iDisplayStopButton, 'Value'))
                    set(obj.iDisplayStopButton, 'Value', 0)
                    obj.reset;
                    break;
                end
                
                obj.vDataSegment = obj.iAudioHandler.waitForData();
                
                obj.vFilteredDataSegment = obj.iFilterBlackBox.process(obj.vDataSegment);
                obj.iSignalHistoryData.store(obj.vFilteredDataSegment);
                size(obj.vDataSegment)
                [obj.nThreshold, obj.vThreshold] = obj.iThreshTracker.calculateThreshold(obj.iSignalHistoryData.vData);
                [vLowPeaks, vHighPeaks] = obj.iThreshGuard.detectPeaks(obj.vFilteredDataSegment, obj.nThreshold);
                obj.iSignalHistoryHighPeaks.store(vHighPeaks);
                obj.iSignalHistoryLowPeaks.store(vLowPeaks);
                nHR = obj.iHRCalculator.calculateHeartRate();
                
                %obj.iDataRecorder.store(obj.vFilteredDataSegment);    
                obj.iDataDisplay.showData(obj.iSignalHistoryData.vData, obj.iSignalHistoryHighPeaks.vData, ...
                    obj.iSignalHistoryLowPeaks.vData, obj.vThreshold, nHR);
            end
        end
    end
end