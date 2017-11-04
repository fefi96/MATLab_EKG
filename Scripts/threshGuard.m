classdef threshGuard < handle
    
    properties(GetAccess = 'private', SetAccess = 'private')
        iHRCalculator;
        iSignalHistoryHighPeaks;
        iSignalHistoryLowPeaks;
    end
    
    methods
        function obj = threshGuard(nStoreSize, iHRCalculator)
            obj.iHRCalculator = iHRCalculator;
            obj.iSignalHistoryHighPeaks = signalHistory(nStoreSize);
            obj.iSignalHistoryLowPeaks(nStoreSize);
        end
        
        function [vHighPeaks, vLowPeaks] = detectPeaks(obj, vDataSegment, nThreshold)
            
            nLength = length(vDataSegment);
            
            vCurrentPeaks = NaN;
            bOverThreshold = false;
            
            for i = 1:nLength
                
                obj.iSignalHistoryHighPeaks.store(NaN);
                obj.iSignalHistoryLowPeaks.store(NaN);
                
                if(vDataSegment(i) > nThreshold)
                    bOverThreshold = true;
                    vCurrentPeaks(i) = vDataSegment(i);
                else  
                    if(bOverThreshold)                        
                        [~, I] = max(vCurrentPeaks);
                        obj.iHRCalculator.tellIndex(I);
                        disp(['Telling Index: ' num2str(I)]);
                        obj.iSignalHistoryHighPeaks.vData(I) = vCurrentPeaks(I);
                        obj.iSignalHistoryLowPeaks.vData(I) = nThreshold;
                        vCurrentPeaks = NaN;
                    end      
                end
            end
            
            vHighPeaks = obj.iSignalHistoryHighPeaks.vData;
            vLowPeaks = obj.iSignalHistoryLowPeaks.vData;
        end
    end
end