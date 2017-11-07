classdef threshTracker < handle
    
    properties(GetAccess = 'private', SetAccess = 'private')
        iOldThresholds
        vThreshold
        weightOldThresholds = 5
        weightSTD = 2
    end
    
    methods
        function obj = threshTracker(nDataSegmentSize)
            obj.iOldThresholds = signalHistory(25);
            obj.vThreshold = zeros(1, nDataSegmentSize);
            nDataSegmentSize
        end
        
        function [nThreshold, vThreshold] = calculateThreshold(obj, vDataSegment)
            nNewThreshold = mean(vDataSegment) + obj.weightSTD * std(vDataSegment);
            
            nThreshold = (((mean(obj.iOldThresholds.vData) * obj.weightOldThresholds) + nNewThreshold) / (obj.weightOldThresholds + 1));
            obj.iOldThresholds.store(nThreshold);
            vThreshold = obj.getVisualThreshold(nThreshold);
        end
        
        function vThreshold = getVisualThreshold(obj, nThreshold)
            obj.vThreshold(1:end) = nThreshold;
            vThreshold = obj.vThreshold;
        end
    end
end