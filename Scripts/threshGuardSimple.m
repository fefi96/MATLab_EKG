classdef threshGuardSimple < handle
    
    
    properties(Access = 'private')
        iHRCalculator;
        bOverThreshold = false;
        nCurrentTicks = 0;
    end
    
    methods(Access = 'public')
        function obj= threshGuardSimple(iHRCalculator)
            obj.iHRCalculator = iHRCalculator;
        end
        
        function [vLowPeaks, vHighPeaks] = detectPeaks(obj, vDataSegment, nThreshold)
            nLength = length(vDataSegment);
            vLowPeaks = NaN(1, nLength);
            vHighPeaks = NaN(1, nLength);
            
            for i = 1:nLength
                
                obj.nCurrentTicks = obj.nCurrentTicks + 1;
                
                if(vDataSegment(i) > nThreshold)
                    if(~obj.bOverThreshold)
                        
                        if(obj.iHRCalculator.calculateTimeBetween(obj.nCurrentTicks) > 0.2)
                            obj.iHRCalculator.tellTicks(obj.nCurrentTicks);
                            vHighPeaks(i) = vDataSegment(i);
                            obj.nCurrentTicks = 0;
                        end
                    end
                    
                    obj.bOverThreshold = true;
                else
                    obj.bOverThreshold = false;
                end
            end
        end
    end
end

