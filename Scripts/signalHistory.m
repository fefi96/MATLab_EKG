classdef signalHistory < handle
    properties(GetAccess = 'public', SetAccess = 'private')
        vData
    end
    
    properties(GetAccess = 'private', SetAccess = 'private')
        nSize
    end
    
    methods(Access = 'public')
        function obj = signalHistory(nSize)
            obj.nSize = nSize;
        end
        
        function store(obj, vSignalSegment)
            
            if(length(obj.vData) + length(vSignalSegment) <= obj.nSize)
                obj.vData = [obj.vData vSignalSegment];
            end
        end
    end
end