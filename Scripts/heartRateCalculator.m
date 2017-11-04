 classdef heartRateCalculator < handle
    
    properties(GetAccess = 'private', SetAccess = 'private')
        nRate;
        nLastIndex;
        nCurrentIndex;
    end
    
    methods(Access = 'public')
        function obj = heartRateCalculator(nRate)
            obj.nRate = nRate;
            obj.nLastIndex = NaN;
            obj.nCurrentIndex = NaN;
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
            
            if(isfinite(obj.nLastIndex) && isfinite(obj.nCurrentIndex))
               nHR = (obj.nCurrentIndex - obj.nLastIndex) / obj.nRate; 
            end
        end
        
        function tellIndex(obj, nIndex)
           obj.nLastIndex = obj.nCurrentIndex;
           obj.nCurrentIndex = nIndex;
           %disp(['LastIndex: ' num2str(obj.nLastIndex) ', CurrentIndex: ' num2str(obj.nCurrentIndex)]);
        end
    end
end