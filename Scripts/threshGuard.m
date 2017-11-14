classdef threshGuard < handle
    
    properties(GetAccess = 'public', SetAccess = 'private')
        iHRCalculator;
        bOverThreshold = false;
        bCurrentMaxChanged = false;
        nCurrentTicks;
        %vCurrentPeaks;
        nCurrentMax = 0;
        nCurrentMaxIndex = 0;
    end
    
    methods(Access = 'public')
        function obj = threshGuard(iHRCalculator)
            obj.iHRCalculator = iHRCalculator;
            obj.nCurrentTicks = 0;
        end
        
        function [vLowPeaks, vHighPeaks] = detectPeaks(obj, vDataSegment, nThreshold)
            
            
        end
    end
    
    methods(Access = 'private')
        function reset(obj)
            %obj.nCurrentTicks = 0;
            %obj.vCurrentPeaks = [];
            obj.nCurrentMax = 0;
            obj.nCurrentMaxIndex = 0;
        end
    end
end