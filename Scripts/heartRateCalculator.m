classdef heartRateCalculator < handle
    
    properties(GetAccess = 'private', SetAccess = 'private')
        nRate;
        nCurrentTicks;
    end
    
    methods(Access = 'public')
        function obj = heartRateCalculator(nRate)
            obj.nRate = nRate;
            obj.nCurrentTicks = NaN;
        end
        
        %         function calculateHeartRate(obj, vPeaks)
        %
        %             indices = NaN(1, length(vPeaks));
        %             deltas = NaN(1, length(vPeaks));
        %
        %             for i = 1:length(vPeaks)
        %                if(isfinite(vPeaks(i)))
        %                     indices(i) = i;
        %                end
        %             end
        %
        %              indices(~any(~isnan(indices), 2),:)=[];
        %
        %             for j = 1:(length(indices) - 1)
        %                 deltas(i) = (indices(j+1) - indices(j));
        %             end
        %
        %             deltas(~any(~isnan(deltas), 2),:)=[];
        %
        %             nHR = (mean(deltas) / obj.nRate);
        %
        %             %disp(nHR);
        %         end
        
        function nHR = calculateHeartRate(obj)
            nHR = NaN;
            
            if(isfinite(obj.nCurrentTicks))
                nT1 = 0;
                nT2 = obj.calculateTimeBetween(obj.nCurrentTicks);
                nHR = 60 / (nT2 - nT1);
            end
        end
        
        function nTime = calculateTimeBetween(obj, nCurrentTicks)
            nTime = nCurrentTicks / obj.nRate;
        end
        
        function tellTicks(obj, nTicks)
            obj.nCurrentTicks = nTicks;
        end
    end
end