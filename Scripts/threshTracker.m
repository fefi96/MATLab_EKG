classdef threshTracker < handle
    
    properties(GetAccess = 'private', SetAccess = 'private')
        iOldThresholds;
        vThreshold;
        nWeightOldThresholds = 5;
        nWeightSTD = 1;
    end
    
    methods
        function obj = threshTracker(nDataSegmentSize)
            obj.iOldThresholds = signalHistory(25);
            obj.vThreshold = zeros(1, nDataSegmentSize);
        end
        
        function [nThreshold, vThreshold] = calculateThreshold(obj, vDataSegment)
            
            % Method I
            %obj.iOldThresholds.store(mean(vDataSegment) + obj.weightSTD * std(vDataSegment));
            %nThreshold = mean(obj.iOldThresholds.vData);
            
            % Method II
            nNewThreshold = mean(vDataSegment) + obj.nWeightSTD * std(vDataSegment);
            nThreshold = (((mean(obj.iOldThresholds.vData) * obj.nWeightOldThresholds) + nNewThreshold) / (obj.nWeightOldThresholds + 1));
            obj.iOldThresholds.store(nThreshold);
            
            % Method III
            %nThreshold = (sum(obj.iOldThresholds.vData * obj.weightOldThresholds) + nNewThreshold) / (obj.weightOldThresholds * obj.iOldThresholds.nSize + 1);
            %obj.iOldThresholds.store(nThreshold);
            
            vThreshold = obj.getVisualThreshold(nThreshold);
        end
        
        function vThreshold = getVisualThreshold(obj, nThreshold)
            obj.vThreshold(1:end) = nThreshold;
            vThreshold = obj.vThreshold;
        end
    end
end