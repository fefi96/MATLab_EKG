classdef threshGuard < handle
    
    properties(GetAccess = 'private', SetAccess = 'private')
        iHRCalculator;
        bOverThreshold = false;
        vCurrentPeaks = NaN;
    end
    
    methods
        function obj = threshGuard(iHRCalculator)
            obj.iHRCalculator = iHRCalculator;
        end
        
        function [vLowPeaks, vHighPeaks] = detectPeaks(obj, vDataSegment, nThreshold)
            
            nLength = length(vDataSegment);
            vLowPeaks = NaN(1, nLength);
            vHighPeaks = NaN(1, nLength);
            
            for i = 1:nLength
                
                if(vDataSegment(i) > nThreshold)
                    obj.bOverThreshold = true;
                    obj.vCurrentPeaks(i) = vDataSegment(i);
                else  
                    if(obj.bOverThreshold)                        
                        [~, I] = max(obj.vCurrentPeaks);
                        vLowPeaks(I) = nThreshold;
                        vHighPeaks(I) = obj.vCurrentPeaks(I);
                        obj.iHRCalculator.tellIndex(I);
                        %disp(['Telling Index: ' num2str(I)]);                      
                        obj.vCurrentPeaks = NaN;
                    end      
                end
            end
        end
    end
end