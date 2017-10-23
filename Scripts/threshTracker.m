classdef threshTracker < handle
    
   properties(GetAccess = 'private', SetAccess = 'private')
       iOldThresholds
       vThreshold
    end
    
    methods
        function obj = threshTracker(nDataSegmentSize)
            obj.iOldThresholds = signalHistory(25);
            obj.vThreshold = zeros(1, nDataSegmentSize);
        end
        
        function [nThreshold, vThreshold] = calculateThreshold(obj, vDataSegment)
            obj.iOldThresholds.store(mean(vDataSegment) + std(vDataSegment));
            nThreshold = mean(obj.iOldThresholds.vData);
            vThreshold = obj.getVisualThreshold(nThreshold);
        end
        
         function vThreshold = getVisualThreshold(obj, nThreshold)
            obj.vThreshold(1:end) = nThreshold;
            vThreshold = obj.vThreshold;
        end
    end
end