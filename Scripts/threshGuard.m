classdef threshGuard < handle
    
    properties(GetAccess = 'private', SetAccess = 'private')
        %vPeaks
        %bOverThreshold
    end
    
    methods
        function obj = threshGuard(nDataSegmentSize)
            
        end
        
        function vPeaks = detectPeaks(~, vDataSegment, nThreshold)
            
            nLength = length(vDataSegment);
            
            vCurrentPeaks = NaN;
            vPeaks = NaN(1, nLength);
            bOverThreshold = false;
            
            for i = 1:nLength
                
                if(vDataSegment(i) > nThreshold)
                    bOverThreshold = true;
                    vCurrentPeaks(i) = vDataSegment(i);
                else  
                    if(bOverThreshold)                        
                        [~, I] = max(vCurrentPeaks);
                        vPeaks(I) = vCurrentPeaks(I);
                        vCurrentPeaks = NaN;
                    end      
                end
            end
        end
    end
end