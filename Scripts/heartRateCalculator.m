classdef heartRateCalculator < handle
        
    properties(GetAccess = 'private', SetAccess = 'private')
        nRate
    end
    
    methods(Access = 'public')
        function obj = heartRateCalculator(nRate)
           obj.nRate = nRate;
        end
        
        function calculateHeartRate(obj, vPeaks)
            
            indices = NaN(1, length(vPeaks));
            deltas = NaN(1, length(vPeaks));
            
            for i = 1:length(vPeaks)
               if(isfinite(vPeaks(i)))
                    indices(i) = i;
               end
            end
            
             indices(~any(~isnan(indices), 2),:)=[];
             
            for j = 1:(length(indices) - 1)
                deltas(i) = (indices(j+1) - indices(j));
            end
            
            deltas(~any(~isnan(deltas), 2),:)=[];
            
            nHR = (mean(deltas) / obj.nRate);
            
            disp(nHR);
        end
    end
end