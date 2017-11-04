classdef signalHistory < handle
    properties(GetAccess = 'public', SetAccess = 'private')
        vData
        nSize
    end
    
    methods(Access = 'public')
        function obj = signalHistory(nSize)
            obj.vData = zeros(1, nSize);
            obj.nSize = nSize;
        end
        
        function store(obj, vSignalSegment)
            if(length(vSignalSegment) <= obj.nSize)
                obj.vData = circshift(obj.vData, -obj.minClamp((length(vSignalSegment) + length(obj.vData) - obj.nSize), 0));
                
                if(iscolumn(vSignalSegment))
                    obj.vData = [obj.vData(1:(abs(obj.nSize - length(vSignalSegment)))) vSignalSegment'];
                elseif(isrow(vSignalSegment))
                    obj.vData = [obj.vData(1:(abs(obj.nSize - length(vSignalSegment)))) vSignalSegment];
                end
            end
        end
        
        function plus(obj, vSignalSegment) 
            obj.store(vSignalSegment);
        end
    end
    
    methods(Access = 'private')
        function value = minClamp(~, value, min)
            value(value < min) = min;
        end
    end
end