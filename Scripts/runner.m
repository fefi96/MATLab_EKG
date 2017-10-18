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
        iThreshTracker
        iThreshGuard
        iHRCalculator
        iDataDisplay
    end
    
    properties(GetAccess = 'private', SetAccess = 'public')
        running
    end
    
    methods(Access = 'public')
        function obj = runner()
%             obj.iAudioHandler = audioHandle(nSamplerate, nPageLenInSamples, nPages);
%             obj.iFilterBlackBox = filterBlackBox(nAudioSampleRate, nDecimationFactor);
%             obj.iThreshTracker = threshTracker();
%             obj.iThreshGuard = threshGuard();
%             obj.iHRCalculator = heartRateCalculator();
            obj.iDataDisplay = dataDisplay(obj);
            obj.running = true;
            while(obj.running)
                % Wiederhole bis Abbruch
                % vDataSegment = iAudioHandler.waitForData();
                % vFiltDataSegment = iFilterBlackBox.process(vDataSegment);
                % mit iThreshTracker Schwelle berechnen
                % mit iThreshGuard Schwelle überwachen
                % mit iHRCalculator aktuelle Herzfrequenz berechnen
                % mit iDataDisplay Signal, Schwellenwert und Herzrate anzeigen
            end
        end
    end
end