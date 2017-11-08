classdef threshGuard < handle
    
    properties(GetAccess = 'private', SetAccess = 'private')
        iHRCalculator;
        bOverThreshold = false;
        nCurrentTicks;
        vCurrentPeaks;
    end
    
    methods(Access = 'public')
        function obj = threshGuard(iHRCalculator)
            obj.iHRCalculator = iHRCalculator;
            obj.nCurrentTicks = 0;
        end
        
        function [vLowPeaks, vHighPeaks] = detectPeaks(obj, vDataSegment, nThreshold)
            
            nLength = length(vDataSegment);
            vLowPeaks = NaN(1, nLength);
            vHighPeaks = NaN(1, nLength);
            
            for i = 1:nLength
                
                obj.nCurrentTicks = obj.nCurrentTicks + 1;
                disp(['nCurrentTicks: ' num2str(obj.nCurrentTicks)]);
                if(vDataSegment(i) > nThreshold)
                    obj.bOverThreshold = true;
                    obj.vCurrentPeaks = [obj.vCurrentPeaks vDataSegment(i)];
                    obj.vCurrentPeaks
                else  
                    if(obj.bOverThreshold)                        
                        [~, maxIndex] = max(obj.vCurrentPeaks);
                        
                        vLowPeaks(maxIndex) = nThreshold;
                        vHighPeaks(maxIndex) = obj.vCurrentPeaks(maxIndex);
                        obj.iHRCalculator.tellTicks(obj.nCurrentTicks);
                        obj.reset();
                    end
                    
                    obj.bOverThreshold = false;
                end
                
                disp(['bOverThreshold: ' num2str(obj.bOverThreshold)]);
            end
        end
    end
    
    methods(Access = 'private')
        function reset(obj)
           obj.nCurrentTicks = 0;
           obj.vCurrentPeaks = [];
        end
    end
end